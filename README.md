# Message Server

This is the repo for a publish-subscribe messaging system based on
[Faye](http://faye.jcoglan.com/).

### Requirements

* Ruby 2.2.4
* Foreman gem
* Redis

### Local setup

* Clone this repo
* cd into the project's directory and `$ bundle install`
* `$ cp config/faye.sample.yml config/faye.yml`
* edit `config/faye.yml` for local development
* `$ foreman start`
* Faye server will listen on `http://localhost:9292/faye`
