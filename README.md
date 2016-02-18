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

### Deployment

#### Pre-requisites

* Production server should meet the same requirements listed above
(in the Requirements section)
* Ensure a user (other than root) exists in the production server (typically
`deploy`) and that such user has:
  * `sudo` privileges
  * password-less sudo privileges
  * password-less login access (via ssh keys)

#### Deployment flow

* `$ cp config/deploy/production.sample.rb config/deploy/production.rb`
* edit `config/deploy/production.rb` to add server IP address
* when you're ready to deploy, just `$ bundle exec cap production deploy`
