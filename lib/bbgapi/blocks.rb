module BBGAPI
  class Blocks
    def self.menulist
      choose do |menu|
        puts "Blocks"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:list) {self.list}
        menu.choices(:create) {self.tbi}
        menu.choices(:update) {self.tbi}
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




    def self.tbi
      puts "This is not yet implemented"
    end

  end
end