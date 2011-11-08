module BBGAPI
  class Blocks_Products
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
      partial = '/api/block_products'
      api_response = BBGAPI::Client.geturl(partial,"")

      api_response.each {|x|
        puts "\n"
        puts "Cost:        #{x["cost"]}"
        puts "ID:          #{x["id"]}"
        puts "Description: #{x["description"]}"
      }
      puts "\n"
    end

    def self.raw
      partial = '/api/block_products'
      api_response = BBGAPI::Client.geturl(partial,"")
      return api_response
    end


    def self.tbi
      puts "This is not yet implemented"
    end
  end
end