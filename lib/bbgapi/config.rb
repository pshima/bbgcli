#
# Thin wrapper for a YAML config file, whose interface is a Hash
# Probably could have subclassed Hash but for simplicity's sake,
# here we are.
#

module BBGAPI
  class Config

    # Constructor
    # Try to load the config file and fall back to making one
    def initialize(config_path)
      # This somewhat violates the separation of concern as
      # the Config class probably shouldn't have to deal with
      # the user, but it maintains the original code intent.
      @config_path = config_path
      @config = {}
      load || create
    end

    # Load a YAML config file
    # * +config_path+ :: config file path
    def load
      begin
        @config = YAML.load_file(@config_path)
      rescue
        nil
      end
    end

    # Save a YAML config file
    # * +config_path+ :: config file path
    def save
      File.open(@config_path, 'w') do |out|
        out.write(@config.to_yaml)
      end
    end

    # Make a YAML config file
    # * +config+ :: config file path
    def create
      puts "Blue Box Config File Not Found, let's create one..."
      bbg_cust_id = ask("BBG Customer ID:  ") { |q| q.default = "none" }
      bbg_api_key = ask("BBG API Key:  ") { |q| q.default = "none" }

      puts "#{bbg_cust_id}:#{bbg_api_key}"

      @config = {
        'bluebox_customer_id' => bbg_cust_id,
        'bluebox_api_key' => bbg_api_key
      }
      save
    end

    # A quick read accessor for the +@config+ hash
    def [](key)
      @config[key.to_s]
    end

    # A quick write accessor for the +@config+ hash
    def []=(key, value)
      @config[key.to_s] = value
    end

  end
end
