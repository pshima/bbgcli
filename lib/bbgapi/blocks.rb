module BBGAPI
  class Blocks
    def self.menulist
      choose do |menu|
        puts "Blocks"
        puts "----------------------------------------"
        menu.prompt = "Which Action?"

        menu.choices(:list) {self.list}
        menu.choices(:create) {self.create}
        menu.choices(:delete) {self.tbi}
      end
    end

    def self.list
      partial = '/api/blocks'
      api_response = BBGAPI::Client.geturl(partial,"")

      api_response.each {|x|
        puts "\n"
        puts "Name:        #{x["hostname"]}"
        puts "ID:          #{x["id"]}"
        puts "External IP: #{x["ips"].first["address"]}"
        if !x["lb_applications"].empty?
          puts "LB App:      #{x["lb_applications"].first["lb_application_name"]}"
        end
      }
      puts "\n"

    end

    def self.find_id_from_name
      partial = '/api/blocks'
      api_response = BBGAPI::Client.geturl(partial,"")

      machines=api_response.first["lb_machines"]
      hostname = "#{id}.c45451"
      srv = machines.find_all{|item| item["hostname"] == hostname }
      srv_id = srv.first["id"]

    end

    def self.raw
      partial = '/api/blocks'
      api_response = BBGAPI::Client.geturl(partial,"")
      return api_response
    end

    def self.productmenu
      products = BBGAPI::Blocks_Products.raw
      choose do |menu|
        menu.prompt = "Which Product Would You Like?"
        products.each {|product|
          menu.choices(product["description"]) {return product["id"]}
        }
      end
    end

    def self.templatemenu
      templates = BBGAPI::Blocks_Templates.raw
      choose do |menu|
        menu.prompt = "Which Template Would You Like?"
        templates.each {|template|
          menu.choices(template["description"]) {return template["id"]}
        }
      end
    end

    def self.create
      productid = self.productmenu
      templateid = self.templatemenu
      ssh_key_file = File.new("#{ENV['HOME']}/.ssh/id_rsa.pub", "r")
      keyfile = ssh_key_file.gets
      hostname = ask("Hostname:  ")

      options = { :body => {
        :product => productid,
        :template => templateid,
        :ssh_public_key => keyfile,
        :hostname => hostname
        } }

      partial = '/api/blocks'
      api_response = BBGAPI::Client.posturl(partial,options)
      if api_response.code == 200
        puts "Name: #{api_response["hostname"]}"
        puts "IP: #{api_response["ips"].first["address"]}"
        puts "Status: #{api_response["status"]}"
        puts "\n"
        puts "Sleeping 5 minutes while server boots up"
        sleep 300
        choose do |menu|
          menu.prompt = "Do you want to ssh to this new server?"
          menu.choices(:yes) {
            system("open", "ssh://deploy@#{api_response["ips"].first["address"]}")
          }
          menu.choices(:no)
        end
        choose do |menu|
          menu.prompt = "Do you want to bootstrap this new server?"
          menu.choices(:yes) {
            
            ssh_host = api_response["ips"].first["address"]
            ssh_user = 'deploy'

            begin
              Net::SSH.start( ssh_host, ssh_user ) do|ssh|
                output = ssh.exec('sudo chmod +x /root/bootstrap.sh && sudo /root/bootstrap.sh')
                puts output
              end
            rescue Net::SSH::HostKeyMismatch => e
              puts "remembering new key: #{e.fingerprint}"
              e.remember_host!
              retry
            end
          }
          menu.choices(:no)
        end
        choose do |menu|
          menu.prompt = "Do you want to add this machine to a load balanced pool?"
          menu.choices(:yes) {

            ssh_host = api_response["ips"].first["address"]
            ssh_user = 'deploy'

            begin
              Net::SSH.start( ssh_host, ssh_user ) do|ssh|
                output = ssh.exec('sudo chmod +x /root/tools/lb_add.sh && sudo /root/tools/lb_add.sh autoadd')
                puts output
              end
            rescue Net::SSH::HostKeyMismatch => e
              puts "remembering new key: #{e.fingerprint}"
              e.remember_host!
              retry
            end
          }
          menu.choices(:no)
        end
      else
        #puts "Recieved a #{api_response.code} to the request"
      end
    end


    def self.tbi
      puts "This is not yet implemented\n"
    end

  end
end