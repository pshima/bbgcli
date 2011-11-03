
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

    def self.help
      puts "test"
    end

    def self.geturl(partial, opts={})
      url = "#{API_URL}#{partial}"
      format :json
      response = get(url)
      if @debug
        puts "Response Code: #{response.code}"
        puts "Response RAW: #{response}"
      end
      response
    end

    def self.posturl
      # alternatively:
      # raise NotImplementedError, "bla"
      puts "bla"
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
          menu.choices(:easy) {BBGAPI::LB_Easy.menulist}
          menu.choices(:advanced) {BBGAPI::Client.lb_advanced}
          menu.choices(:exit) {exit 0}
          puts "\n"
        end
      when "blocks"
        # alternatively:
        # raise NotImplementedError, "blocks"
        puts "blocks"
      when "servers"
        choose do |menu|
          puts "Servers API - http://bit.ly/uDd6wQ"
          puts "----------------------------------------"
          menu.prompt = "Which Objects Would You Like?  "

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
