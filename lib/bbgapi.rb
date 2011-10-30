require 'pp'
require 'rubygems'
require 'highline'
require 'highline/import'
require 'httparty'
require 'yaml'
require 'bbgapi/config'
require 'bbgapi/lb_applications'
require 'bbgapi/lb_backends'
require 'bbgapi/lb_services'

module BBGAPI

  @@debug = false

  def self.config
    @@bluebox_config ||= BBGAPI::Config.new('./bluebox.yaml')
  end

  def self.debug
    @@debug = true
  end

  @@credentials = {
   :bluebox_customer_id => @@bluebox_config["bluebox_customer_id"],
   :bluebox_api_key => @@bluebox_config["bluebox_api_key"]
  }

  def self.help
    puts "test"
  end

  def self.query(partial,request)
    url = "#{@@api_url}#{partial}"
    response = get(url)
  end

  def self.geturl(partial, opts={})
    url = "#{@@api_url}#{partial}"
    format :json
    response = get(url)
    if @@debug
      puts "Response Code: #{response.code}"
      puts "Response RAW: #{response}"
    end
    response
  end

  def self.posturl
    puts "bla"
  end

  def self.puturl
    puts "bla"
  end

  def self.parseopt(type="",action="",id="")
    ssh_key_file = File.new("#{ENV['HOME']}/.ssh/id_rsa.pub", "r")
    keyfile = ssh_key_file.gets
    include HTTParty

    ## setup api domain
    #@@api_url = "https://#{@@credentials[:bluebox_customer_id]}:#{@@credentials[:bluebox_api_key]}\@boxpanel.bluebox.net"
    @@api_url = "https://boxpanel.bluebox.net"
    basic_auth "#{@@credentials[:bluebox_customer_id]}", "#{@@credentials[:bluebox_api_key]}"


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
      puts "blocks"
    when "servers"
      puts "servers"
    when "help"
      BBGAPI::help
    else
      "Invalid --api option, try --help"
    end
    # Squire.scribble("INFO","200 Successfully Retrieved #{type} data from Blue Box"); return response if response.code == 200
  end

end
