module BBGAPI
  class Servers

    def self.menulist
      choose do |menu|
        puts "Servers"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:list) {self.list}
      end
    end

    def self.list
      partial = '/api/servers'
      api_response = BBGAPI::Client.geturl(partial,"")
      nodes = api_response.sort_by {|var| var["hostname"]}
      nodes.each {|x|
        puts "\n"
        puts "Name:        #{x["hostname"]}"
        puts "ID:          #{x["id"]}"
        puts "Description: #{x["description"]}"
        puts "IP:          #{x["ips"].first["address"]}"
        puts "Status:      #{x["status"]}"
      }
      puts "\n"

      choose do |menu|
        menu.prompt = "Would you like to list extended information?"

        menu.choices(:yes) {self.fulllist}
        menu.choices(:no)
      end
    end

    def self.raw
      partial = '/api/servers'
      api_response = BBGAPI::Client.geturl(partial,"")
      nodes = api_response.sort_by {|var| var["hostname"]}
      return nodes
    end

    def self.fulllist
      partial = '/api/servers'
      api_response = BBGAPI::Client.geturl(partial,"")
      nodes = api_response.sort_by {|var| var["hostname"]}
      nodes.each {|x|
        puts "\n"
        puts "Name:        #{x["hostname"]}"
        puts "ID:          #{x["id"]}"
        puts "Description: #{x["description"]}"
        puts "IP:          #{x["ips"].first["address"]}"
        puts "Status:      #{x["status"]}"
        puts "CPU:         #{x["cpu"]}"
        puts "Memory:      #{x["memory"]}"
        puts "Storage:     #{x["storage"]}"
        puts "Load Balancers:"
        x["lb_applications"].each {|y|
          puts y["lb_application_name"]
        }
      }
      puts "\n"

    end
  end
end