
module BBGAPI
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

    def debug!
      @debug = true
    end

    def help
      puts "test"
    end

    def geturl(partial, opts={})
      url = "#{API_URL}#{partial}"
      format :json
      response = get(url)
      if @debug
        puts "Response Code: #{response.code}"
        puts "Response RAW: #{response}"
      end
      response
    end

    def posturl
      # alternatively:
      # raise NotImplementedError, "bla"
      puts "bla"
    end

    def puturl
      # alternatively:
      # raise NotImplementedError, "bla"
      puts "bla"
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
          menu.prompt = "Which Objects Would You Like?  "

          menu.choices(:applications) {BBGAPI::LB_Applications.menulist}
          menu.choices(:services) {BBGAPI::LB_Services.menulist}
          menu.choices(:backends) {BBGAPI::LB_Backends.menulist}
          menu.choices(:machines)
          menu.choices(:exit) {exit 0}
        end
      when "blocks"
        # alternatively:
        # raise NotImplementedError, "blocks"
        puts "blocks"
      when "servers"
        # alternatively:
        # raise NotImplementedError, "servers"
        puts "servers"
      when "help"
        help
      else
        "Invalid --api option, try --help"
      end
    end

  end
end
