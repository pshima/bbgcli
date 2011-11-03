module BBGAPI
  class LB_Easy


    def self.menulist
      choose do |menu|
        puts "Load Balancer Easy Functions"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:get_haproxy_login) {self.haproxy_login}
        menu.choices(:find_machines_in_pool) {self.machines_in_pool}

      end
    end

    def self.haproxy_login
      haproxy = BBGAPI::LB_Services.haproxyinfo
      puts "-----Needs improvement but should work for now"
      haproxy.each {|x|
        puts "#{x["name"]} - URL: #{x["status_url"]} #{x["status_username"]}:#{x["status_password"]} "
      }
      puts "------------------"
    end

    def self.machines_in_pool
      nodes = BBGAPI::LB_Backends.raw
      puts "\nNodes in Pool:\n"
      nodes.first["lb_machines"].each {|x| puts "#{x["hostname"]}"}
      puts "\n"
    end


  end
end