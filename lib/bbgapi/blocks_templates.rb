module BBGAPI
  class Blocks_Templates
    def self.menulist
      choose do |menu|
        puts "Block Templates"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:list) {self.list}
        menu.choices(:create) {self.tbi}
        menu.choices(:update) {self.tbi}
        menu.choices(:delete) {self.tbi}
      end
    end

    def self.list
      partial = '/api/block_templates'
      api_response = BBGAPI::Client.geturl(partial,"")

      srv = api_response.find_all{|item| !item["public"] }
      sorted = srv.sort_by {|a| a["created"]}.reverse

      puts "Last 10 Images:"

      sorted.each_with_index {|x,i|
        break if i == 10;
        puts "#{x["description"]} - #{x["id"]}"
      }
      puts "\n"

      pubsrv = api_response.find_all{|item| item["public"] }
      pubsorted = pubsrv.sort_by {|a| a["description"]}

      puts "Public Images (limit 10):"

      pubsorted.each_with_index {|x,i|
        break if i == 10;
        puts "#{x["description"]} - #{x["id"]}"
      }
      puts "\n"

    end

    def self.tbi
      puts "This is not yet implemented"
    end
  end
end