 #!/usr/bin/env ruby

require './lib/bbgapi.rb'
require 'trollop'


opts = Trollop::options do
    version "bbgcli 0.0.1 - Pete Shima <pete@kingofweb.com>"
  banner <<-EOS
This program gives you an interactive cli to the Blue Box Group api

Usage:
       test [options] <filenames>+
where [options] are:
EOS

  opt :api, "lb|blocks|servers", :type => String
  opt :object, "Be interactive", :type => String
  opt :action, "obkect action", :type => String
  opt :item, "File to process", :type => String
  opt :debug, "Debug Mode", :default => false
end


Trollop::die :api, "You must specify an API" if opts[:api] == ""


#BBGAPI::debug

BBGAPI::parseopt(opts[:api],opts[:action])