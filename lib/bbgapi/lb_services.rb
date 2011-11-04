module BBGAPI
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
      choose do |menu|
        menu.prompt = "Which Application?"
        apps.each {|k|
          menu.choices(k["name"]) {
            BBGAPI::LB_Applications.set_app(k["id"])
            cur_app = k["id"]
          }
        }
      end
      return BBGAPI::LB_Applications.get_app
    end

    def self.list
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::Client.geturl(partial,"")
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
    end

    def self.create
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      choose do |menu|
        menu.prompt = "HTTP or HTTPS?"
        menu.choices(:http) {service_type="http"}
        menu.choices(:https) {service_type="https"}
      end

      options = { :body => {
        :service_type => service_type
        } }

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::Client.posturl(partial,options)
      pp api_response
      #puts "Name:         #{api_response["name"]}"

      puts "\n"
    end

    def self.delete
      raw_services = self.raw
      choose do |menu|
        menu.prompt = "Which Service To Delete?"
        raw_services.each {|service|
          menu.choices(service["name"]) {self.delete_confirm(service["name"],service["id"])}
        }
      end
    end

    def self.delete_confirm(name,id)
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      choose do |menu|
        menu.prompt = "Are you sure you want to delete service #{name}?"
        menu.choices(:yes) {
          partial = "/api/lb_applications/#{cur_app}/lb_services/#{id}"
          api_response = BBGAPI::Client.deleteurl(partial)
          pp api_response
        }
        menu.choices(:no)
      end
    end

    def self.only_name_id
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::Client.geturl(partial,"")
      services = []
      api_response.each {|x|
        services << {"name" => "#{x["name"]}","id" => "#{x["id"]}"}
      }
      return services
    end

    def self.raw
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::Client.geturl(partial,"")
      return api_response
    end


    def self.haproxyinfo
      begin
        cur_app = BBGAPI::LB_Applications.get_app
      rescue
        cur_app = self.recurse
      end

      partial = "/api/lb_applications/#{cur_app}/lb_services"
      api_response = BBGAPI::Client.geturl(partial,"")
      haproxy = []
      api_response.each {|x|
        haproxy << {"name" => "#{x["name"]}","status_url" => "#{x["status_url"]}","status_username" => "#{x["status_username"]}","status_password" => "#{x["status_password"]}"}
      }
      return haproxy
    end    

    def self.tbi
      puts "This is not yet implemented"
    end

  end
end
