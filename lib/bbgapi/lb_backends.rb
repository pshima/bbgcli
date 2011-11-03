module BBGAPI
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
      api_response = BBGAPI::Client.geturl(partial,"")
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
    end


    def self.raw
      begin
        cur_app = BBGAPI::LB_Applications.get_app
        cur_service = BBGAPI::LB_Services.get_service
      rescue
        self.recurse
        cur_app = BBGAPI::LB_Applications.get_app
        cur_service = BBGAPI::LB_Services.get_service
      end

      partial = "/api/lb_services/#{cur_service}/lb_backends"
      api_response = BBGAPI::Client.geturl(partial,"")
      return api_response
    end

    def self.tbi
      puts "This is not yet implemented"
    end

  end
end
