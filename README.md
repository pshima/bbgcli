Summary
======

This is a command line interface for the blue box api.

Installing
-------

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

Version 0.0.2
-------
* Added initial blocks code
* Added initial servers code which is complete
* Added easy mode and advanced mode

Todo
----

* Finish load balancer commands other than list
* Finish blocks commands other than list
* Remember default ids in yaml
* Find a way to query the api url less for load concerns/speed
* Safety checks against production
