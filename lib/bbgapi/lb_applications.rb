
module BBGAPI
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

      choose do |menu|
        menu.prompt = "Which App Should I Set as Default?"
        apps.each {|k|
          menu.choices(k["name"]) {self.set_app(k["id"])}
        }
      end
    end

    def self.get_app
      return @@current_app
    end

    def self.set_app (appid="")
      @@current_app = appid
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
