module BBGAPI
  class Blocks
    def self.menulist
      choose do |menu|
        puts "Blocks"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:list) {self.list}
        menu.choices(:create) {self.create}
        menu.choices(:delete) {self.tbi}
      end
    end

    def self.list
      partial = '/api/blocks'
      api_response = BBGAPI::Client.geturl(partial,"")
      pp api_response
      # apps = []
      # api_response.each {|x|
      #   apps << {"name" => "#{x["name"]}","id" => "#{x["id"]}"}
      #   puts "\n"
      #   puts "Name:        #{x["name"]}"
      #   puts "ID:          #{x["id"]}"
      #   puts "Description: #{x["description"]}"
      #   puts "External IP: #{x["ip_v4"]}"
      #   puts "Internal IP: #{x["source_ip_v4"]}"
      #   puts "Created:     #{x["created"]}"
      # }
      # puts "\n"

    end

    def self.raw
      partial = '/api/blocks'
      api_response = BBGAPI::Client.geturl(partial,"")
      return api_response
    end

    def self.productmenu
      products = BBGAPI::Blocks_Products.raw
      choose do |menu|
        menu.prompt = "Which Product Would You Like?"
        products.each {|product|
          menu.choices(product["description"]) {return product["id"]}
        }
      end
    end

    def self.templatemenu
      templates = BBGAPI::Blocks_Templates.raw
      choose do |menu|
        menu.prompt = "Which Template Would You Like?"
        templates.each {|template|
          menu.choices(template["description"]) {return template["id"]}
        }
      end
    end

    def self.create
      productid = self.productmenu
      templateid = self.templatemenu
      ssh_key_file = File.new("#{ENV['HOME']}/.ssh/id_rsa.pub", "r")
      keyfile = ssh_key_file.gets
      hostname = ask("Hostname:  ")

      options = { :body => {
        :product => productid,
        :template => templateid,
        :ssh_public_key => keyfile,
        :hostname => hostname
        } }

      partial = '/api/blocks'
      api_response = BBGAPI::Client.posturl(partial,options)
      if api_response.code == 200
        puts "Name: #{api_response["hostname"]}"
        puts "IP: #{api_response["ips"].first["address"]}"
        puts "Status: #{api_response["status"]}"
        puts "\n"
        choose do |menu|
          menu.prompt = "Do you want to ssh to this new server?"
          menu.choices(:yes) {
            puts "sleeping 5 minutes" # really 3 minutes but will feel like 5.
            sleep 180
            system("open", "ssh://deploy@#{api_response["ips"].first["address"]}")
          }
          menu.choices(:no)
        end
      else
        puts "Recieved a #{api_response.code} to the request"
      end
    end


    def self.tbi
      puts "This is not yet implemented\n"
    end

  end
end