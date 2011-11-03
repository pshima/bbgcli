module BBGAPI
  class LB_Easy


    def self.menulist
      choose do |menu|
        puts "Load Balancer Easy Functions"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:haproxy_login) {self.haproxy_login}
        menu.choices(:create) {self.tbi}
        menu.choices(:update) {self.tbi}
        menu.choices(:delete) {self.tbi}
      end
    end

    def self.haproxy_login
      haproxy = BBGAPI::LB_Services.haproxyinfo
      haproxy.each {|x|
        puts "#{x["name"]} - URL: #{x["status_url"]} #{x["status_username"]}:#{x["status_password"]} "
      }
    end



  end
end