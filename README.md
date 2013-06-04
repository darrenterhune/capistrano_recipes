Capistrano Recipes
==================

A collection of recipes for capistrano for ease of bootstrapping and deploying applications

List of current recipes:

* Base
* Check
* Config
* DelayedJob
* Memcached
* Monit
* MySQL
* Nginx
* Nodejs
* Postfix
* Rbenv
* Sphinx
* SSH
* Unicorn

Requirements
============

You will need a `/config/setup_config.yml` file which is loaded into `/recipes/base.rb` to keep private stuff out of scm.

You will need a `/config/ssl` directory with certificate files that match `/recipes/config.rb`

You will need a `/config/database.yml` file to work with `/recipes/mysql.rb` or `/recipes/postgresql.rb`

Probably other stuff, not all code is tested or tried!