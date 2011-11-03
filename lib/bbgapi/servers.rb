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
      apps = []
      pp api_response

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

  end
end