module BBGAPI

#you need httparty gems installed
require 'httparty'
require 'highline'
require 'highline/import'
require 'pp'
  
  @@debug = false

  begin
    @@bluebox_config = YAML.load_file('./bluebox.yaml')
  rescue => e
    puts "Blue Box Config File Not Found, let's create one..."
    bbg_cust_id = ask("BBG Customer ID:  ") { |q| q.default = "none" }
    bbg_api_key = ask("BBG API Key:  ") { |q| q.default = "none" }

    puts "#{bbg_cust_id}:#{bbg_api_key}"

    a = {'bluebox_customer_id' => bbg_cust_id, 'bluebox_api_key' => bbg_api_key}
    File.open('bluebox.yaml', 'w') do |out|
      out.write(a.to_yaml)
    end
    @@bluebox_config = YAML.load_file('./bluebox.yaml')
  end 

  def self.config
    @@bluebox_config
  end

  def self.debug
    @@debug = true
  end

  @@credentials = {
   :bluebox_customer_id => @@bluebox_config["bluebox_customer_id"],
   :bluebox_api_key => @@bluebox_config["bluebox_api_key"]
  }

  def self.help
    puts "test"
  end

  def self.query(partial,request)
    url = "#{@@api_url}#{partial}"
    response = get(url)
  end

  def self.geturl(partial, opts={})
    url = "#{@@api_url}#{partial}"
    format :json
    response = get(url)
    if @@debug
      puts "Response Code: #{response.code}"
      puts "Response RAW: #{response}"
    end
    response
  end

  def self.posturl
    puts "bla"
  end

  def self.puturl
    puts "bla"
  end

  class LB_Applications

    def self.menulist
        choose do |menu|
          puts "Load Balancer Applications"
          puts "----------------------------------------"
          menu.prompt = "Which Action?"

          menu.choices(:list) {self.list}
          menu.choices(:create) {self.tbi}
          menu.choices(:update) {self.tbi}
          menu.choices(:delete) {self.tbi}
        end
    end

    def self.list
      partial = '/api/lb_applications'
      api_response = BBGAPI::geturl(partial,"")
      apps = []
      api_response.each {|x|
        apps << {"name" => "#{x["name"]}","id" => "#{x["id"]}"}
        puts "\n"
        puts "Name:        #{x["name"]}"
        puts "ID:          #{x["id"]}"
        puts "Description: #{x["description"]}"
        puts "External IP: #{x["ip_v4"]}"
        puts "Internal IP: #{x["source_ip_v4"]}"
        puts "Created:     #{x["created"]}"
      }
      puts "\n"

      choose do |menu|
        menu.prompt = "Which App Should I Set as Default?"
        apps.each {|k|
          menu.choices(k["name"]) {self.set_app(k["id"])}
        }
      end
      BBGAPI::parseopt("lb")
    end

    def self.get_app
      return @@current_app
    end

    def self.set_app (appid="")
        @@current_app = appid
    end

    def self.only_name_id
      partial = '/api/lb_applications'
      api_response = BBGAPI::geturl(partial,"")
      apps = []
      api_response.each {|x|
        apps << {"name" => "#{x["name"]}","id" => "#{x["id"]}"}
      }
      return apps
    end

    def self.tbi
      puts "This is not yet implemented"
      BBGAPI::parseopt("lb")
    end

  end

  class LB_Services
    def self.menulist
        choose do |menu|
          puts "Load Balancer Services"
          puts "----------------------------------------"
          menu.prompt = "Which Action?"
          menu.choices(:list) {self.list}
          menu.choices(:create) {self.tbi}
          menu.choices(:update) {self.tbi}
          menu.choices(:delete) {self.tbi}
        end
    end

    def self.get_service
      return @@current_service
    end

    def self.set_service (serviceid="")
        @@current_service = serviceid
    end

    def self.recurse
      apps = BBGAPI::LB_Applications.only_name_id
      pp apps
      exit 0
      choose do |menu|
        menu.prompt = "Which Application?"
        apps.each {|k|
          menu.choices(k["name"]) {
            BBGAPI::LB_Applications.set_app(k["id"])
            cur_app = k["id"]
          }
        }
      end
      return cur_app
    end

    def self.list
      
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::geturl(partial,"")
      api_response.each {|x|
        puts "\n"
        puts "Name:         #{x["name"]}"
        puts "ID:           #{x["id"]}"
        puts "Description:  #{x["description"]}"
        puts "Port:         #{x["port"]}"
        puts "Service Type: #{x["service_type"]}"
        puts "Status URL:   #{x["status_url"]}"
        puts "Status User:  #{x["status_username"]}"
        puts "Status Pass:  #{x["status_password"]}"
        puts "Created:      #{x["created"]}"
      }
      puts "\n"
      BBGAPI::parseopt("lb")
    end

    def self.only_name_id
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::geturl(partial,"")
      services = []
      api_response.each {|x|
        services << {"name" => "#{x["name"]}","id" => "#{x["id"]}"}
      }
      return services
    end

    def self.tbi
      puts "This is not yet implemented"
      BBGAPI::parseopt("lb")
    end

  end

  class LB_Backends
    def self.menulist
        choose do |menu|
          puts "Load Balancer Backends"
          puts "----------------------------------------"
          menu.prompt = "Which Action?"
          menu.choices(:list) {self.list}
          menu.choices(:create) {self.tbi}
          menu.choices(:update) {self.tbi}
          menu.choices(:delete) {self.tbi}
        end
    end

    def self.recurse
      apps = BBGAPI::LB_Applications.only_name_id
      choose do |menu|
        menu.prompt = "Which Application?"
        apps.each {|k|
          menu.choices(k["name"]) {
            BBGAPI::LB_Applications.set_app(k["id"])
            cur_app = k["id"]
          }
        }
      end

      services = BBGAPI::LB_Services.only_name_id
      choose do |menu|
        menu.prompt = "Which Service?"
        services.each {|k|
          menu.choices(k["name"]) {
            BBGAPI::LB_Services.set_service(k["id"])
            cur_service = k["id"]
          }
        }
      end

    end

    def self.list
      begin
        cur_app = BBGAPI::LB_Applications.get_app
        cur_service = BBGAPI::LB_Services.get_service
      rescue
        self.recurse
        cur_app = BBGAPI::LB_Applications.get_app
        cur_service = BBGAPI::LB_Services.get_service
      end

      partial = "/api/lb_services/#{cur_service}/lb_backends"
      api_response = BBGAPI::geturl(partial,"")
      api_response.each {|x|
        puts "\n"
        puts "Name:            #{x["backend_name"]}"
        puts "ID:              #{x["id"]}"
        puts "Alive Check:     #{x["monitoring_url"]}"
        puts "Check Interval:  #{x["check_interval"]}"
        nodes = x["lb_machines"].sort_by {|var| var["hostname"]}
        nodes.each {|y|
          puts "App:             #{y["hostname"]}"
        }
      }
      puts "\n"
      BBGAPI::parseopt("lb")
    end



    def self.tbi
      puts "This is not yet implemented"
      BBGAPI::parseopt("lb")
    end

  end

  def self.parseopt(type="",action="",id="")
    ssh_key_file = File.new("#{ENV['HOME']}/.ssh/id_rsa.pub", "r")
    keyfile = ssh_key_file.gets
    include HTTParty

    ## setup api domain
    #@@api_url = "https://#{@@credentials[:bluebox_customer_id]}:#{@@credentials[:bluebox_api_key]}\@boxpanel.bluebox.net"
    @@api_url = "https://boxpanel.bluebox.net"
    basic_auth "#{@@credentials[:bluebox_customer_id]}", "#{@@credentials[:bluebox_api_key]}"


    case type
      when "lb"

        choose do |menu|
          puts "Load Balancer API - http://bit.ly/ucbpDF"
          puts "----------------------------------------"
          menu.prompt = "Which Objects Would You Like?  "

          menu.choices(:applications) {BBGAPI::LB_Applications.menulist}
          menu.choices(:services) {BBGAPI::LB_Services.menulist}
          menu.choices(:backends) {BBGAPI::LB_Backends.menulist}
          menu.choices(:machines)
          menu.choices(:exit) {exit 0}
        end

      when "blocks"
        puts "blocks"
      when "servers"
        puts "servers"
      when "help"
        BBGAPI::help
      else
        "Invalid --api option, try --help"
    end
    # Squire.scribble("INFO","200 Successfully Retrieved #{type} data from Blue Box"); return response if response.code == 200

  end






end

