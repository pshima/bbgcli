
module BBGAPI
  class LB_Applications

    def self.menulist
      choose do |menu|
        puts "Load Balancer Applications"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:list) {self.list}
        menu.choices(:create) {self.create}
        menu.choices(:update) {self.tbi}
        menu.choices(:delete) {self.delete}
      end
    end

    def self.list
      partial = '/api/lb_applications'
      api_response = BBGAPI::Client.geturl(partial,"")
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
    end

    def self.create
      app_name = ask("Specify a name for the new app:  ")
      options = { :body => {
        :name => app_name
        } }
      partial = '/api/lb_applications'
      api_response = BBGAPI::Client.posturl(partial,options)
      puts "App Created!"
      puts "Name:        #{api_response["name"]}"
      puts "ID:          #{api_response["id"]}"
      puts "External IP: #{api_response["ip_v4"]}"
      puts "Internal IP: #{api_response["source_ip"]}"
    end

    def self.delete
      raw_apps = self.raw

      choose do |menu|
        menu.prompt = "Which App To Delete?"
        raw_apps.each {|app|
          menu.choices(app["name"]) {self.delete_confirm(app["name"],app["id"])}
        }
      end
    end

    def self.delete_confirm(name,id)
      choose do |menu|
        menu.prompt = "Are you sure you want to delete app #{name}?"

        menu.choices(:yes) {
          partial = "/api/lb_applications/#{id}"
          api_response = BBGAPI::Client.deleteurl(partial)
          pp api_response
        }
        menu.choices(:no)
      end

    end

    def self.get_app
      return @@current_app
    end

    def self.set_app (appid="")
      @@current_app = appid
    end

    def self.raw
      partial = '/api/lb_applications'
      api_response = BBGAPI::Client.geturl(partial,"")
      return api_response
    end

    def self.only_name_id
      partial = '/api/lb_applications'
      api_response = BBGAPI::Client.geturl(partial,"")
      apps = []
      api_response.each {|x|
        apps << {"name" => "#{x["name"]}","id" => "#{x["id"]}"}
      }
      return apps
    end

    def self.tbi
      puts "This is not yet implemented"
    end

  end
end
