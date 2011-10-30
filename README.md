Summary
======

This is a command line interface for the blue box api.

Installing
-------

git clone git@github.com:petey5king/bbgcli.git
cd bbgcli
gem build bbgcli.gemspec
gem install bbgcli-0.0.1.gem

Running
-------

cd bbgcli
ruby bbgcli --api <opts here>

Initial code only allows for --api lb


Todo
-------

Finish load balancer commands other than list
Start the servers api code
Start the blocks api code
Remember default ids in yaml
Find a way to query the api url less for load concerns/speed

