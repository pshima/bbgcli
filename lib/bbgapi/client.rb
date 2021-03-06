
module BBGAPI
  @dnssuffix = '.blueboxgrid.com'

  class Client

    API_URL = "https://boxpanel.bluebox.net"
    include HTTParty

    class << self
      def query(partial, request)
        url = "#{@api_url}#{partial}"
        response = get(url)
      end
    end

    def initialize(config_file)
      @config_file = config_file
      @debug = false
    end

    def config
      @config ||= Config.new(@config_file)
    end

    def load_credentials
      @@credentials = {
        :bluebox_customer_id => self.config["bluebox_customer_id"],
        :bluebox_api_key => self.config["bluebox_api_key"]
      }
    end

    # def self.configload
    #   configload = Config.new(@config_file)
    # end

    def debug!
      @debug = true
    end

    def self.help
      puts "test"
    end

    def self.geturl(partial, opts={})
      url = "#{API_URL}#{partial}"

      response = get(url)

      #puts response.code

      if response.code == 401
        puts "Access denied.  Bad Customer Number or API Key."
        exit 0
      end

      if response.code != 200
        puts "Response code is #{response.code}"
        puts response
        exit 0
      end

      if @debug
        puts "Response Code: #{response.code}"
        puts "Response RAW: #{response}"
      end
      response
    end

    def self.posturl(partial, opts={})
      url = "#{API_URL}#{partial}"
      response = post(url,opts)
      return response
    end

    def self.deleteurl(partial)
      url = "#{API_URL}#{partial}"
      response = delete(url)
      return response
    end
    
    def self.puturl
      # alternatively:
      # raise NotImplementedError, "bla"
      puts "bla"
    end

    def self.lb_advanced
        choose do |menu|
          puts "Load Balancer API - http://bit.ly/ucbpDF"
          puts "----------------------------------------"
          menu.prompt = "Which Objects Would You Like?  "

          menu.choices(:applications) {BBGAPI::LB_Applications.menulist}
          menu.choices(:services) {BBGAPI::LB_Services.menulist}
          menu.choices(:backends) {BBGAPI::LB_Backends.menulist}
          menu.choices(:machines)
          menu.choices(:exit) {exit 0}
        end
    end

    def self.blocks_advanced
        choose do |menu|
          puts "Load Balancer API - http://bit.ly/ucbpDF"
          puts "----------------------------------------"
          menu.prompt = "Which Objects Would You Like?  "

          menu.choices(:blocks) {BBGAPI::Blocks.menulist}
          menu.choices(:templates) {BBGAPI::Blocks_Templates.menulist}
          menu.choices(:products) {BBGAPI::Blocks_Products.menulist}
          menu.choices(:exit) {exit 0}
        end
    end

    def parseopt(type="",action="",id="")
      ssh_key_file = File.new("#{ENV['HOME']}/.ssh/id_rsa.pub", "r")
      keyfile = ssh_key_file.gets
      self.class.basic_auth config[:bluebox_customer_id], config[:bluebox_api_key]

      case type
      when "lb"
        choose do |menu|
          puts "Load Balancer API - http://bit.ly/ucbpDF"
          puts "----------------------------------------"
          menu.prompt = "Easy or Advanced Mode?  "
          menu.choices(:open_documentation) {system("open", "http://bit.ly/ucbpDF")} #fuck windows anyway
          menu.choices(:easy_mode) {BBGAPI::LB_Easy.menulist(self.config)}
          menu.choices(:advanced_mode) {BBGAPI::Client.lb_advanced}
          menu.choices(:exit) {exit 0}
          puts "\n"
        end
      when "blocks"
        choose do |menu|
          puts "Blocks API - http://bit.ly/v9FtWW"
          puts "----------------------------------------"
          menu.prompt = "Easy or Advanced Mode?  "
          menu.choices(:open_documentation) {system("open", "http://bit.ly/v9FtWW")} #fuck windows anyway
          menu.choices(:easy_mode) {BBGAPI::LB_Easy.menulist}
          menu.choices(:advanced_mode) {BBGAPI::Client.blocks_advanced}
          menu.choices(:exit) {exit 0}
          puts "\n"
        end
      when "servers"
        choose do |menu|
          puts "Servers API - http://bit.ly/uDd6wQ"
          puts "----------------------------------------"
          menu.prompt = "Which Objects Would You Like?  "
          menu.choices(:open_documentation) {system("open", "http://bit.ly/uDd6wQ")} #fuck windows anyway
          menu.choices(:list) {BBGAPI::Servers.list}
          menu.choices(:exit) {exit 0}
        end
      when "help"
        help
      else
        "Invalid --api option, try --help"
      end
    end

  end
end
