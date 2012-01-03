Summary
======

This is a command line interface for the blue box api.  This is currently used in production but use at your own risk!

Installing
-------

    gem install bbgcli

Upgrading
-------

    rm ~/.bbgcli  (or move somewhere for key backup)
    gem install bbgcli

Running
-------

    bbgcli --api <lb|servers|blocks>

Setup
-------

    To setup bbcli with your blue box api credentials just run the app.

    bash$ bbgcli --api lb
    Blue Box Config File Not Found, let's create one...
    BBG Customer ID:  |none|  <enter customer id here>
    BBG API Key:  |none|  <enter api key here>
    Config file written, please rerun the app

Interactive interface
-------
    bash$ bbgcli --api lb
    Load Balancer API - http://bit.ly/ucbpDF
    ----------------------------------------

    1. open_documentation
    2. easy_mode
    3. advanced_mode
    4. exit
    Easy or Advanced Mode?  

    Advanced Mode:

    Load Balancer API - http://bit.ly/ucbpDF
    ----------------------------------------
    1. applications
    2. services
    3. backends
    4. machines
    5. exit

    And More!


Version 0.0.4
-------
* Blocks API listing now shows formatted output
* New server creation on blocks now prompts for ssh, bootstrap and load balancer additions after server startup
* Bootstrap and load balancer additions require specific files present on machine and executes them remotely.  Examples to be provided later.
* Gemspec updated to include new net:ssh requirement
* Fixed server sleep time to actually be 5 minutes before boot.  3 minutes would typically fail.


Version 0.0.3
-------
* Create and delete load balancer applications
* Create and delete load balancer services
* Fixed showing help if no command line options are given
* Create blocks from templates
* Create templates from VPS or Blocks


Version 0.0.2
-------
* Added initial blocks code
* Added initial servers code which is complete
* Added easy mode and advanced mode

Todo
----

* Finish load balancer commands other than list
* More error checking
* Finish blocks commands other than list
* Remember default ids in yaml
* Add additional configuration options for noting production setups and prompt user for initial config
* Find a way to query the api url less for load concerns/speed
* Safety checks against production


