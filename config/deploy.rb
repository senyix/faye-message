# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "faye_message_server"
set :user, "deploy"
set :repo_url, "git@github.com:resuelve-tu-deuda/faye-message-server.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/apps/#{fetch(:application)}"

set :faye_pid, "#{deploy_to}/shared/tmp/pids/faye.pid"
set :faye_config, "#{deploy_to}/current/config.ru"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :ssh_options, { forward_agent: true }

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push("config/faye.yml")

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).
  push(
    "log",
    "tmp/pids",
    "tmp/cache",
    "tmp/sockets"
  )

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc "Copy files"
  task :copy do
    on roles(:app) do |host|
       %w[ faye.yml ].each do |file|
          upload! "config/#{file}", "#{shared_path}/config/#{file}"
       end
    end
  end

  desc "Remove dotfiles"
  task :remove_dotfiles do
    on roles(:app) do |host|
      %w(.ruby-version).each do |dot_file|
        execute :rm, "#{release_path}/#{dot_file}"
      end
    end
  end

  before "check:linked_files", :copy
  after :updated, :remove_dotfiles

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, "cache:clear"
      # end
    end
  end
end

namespace :faye do
  desc "Start Faye"
  task :start do
    on roles(:app) do
      within(release_path) do
        execute :rbenv, :sudo, "bundle exec puma #{fetch(:faye_config)} -e production -d --pidfile #{fetch(:faye_pid)}"
      end
    end
  end

  desc "Stop Faye"
  task :stop do
    on roles(:app) do
      execute :sudo, :kill, "`cat #{fetch(:faye_pid)}` || true"
    end
  end
end

before 'deploy:updated', 'faye:stop'
after 'deploy:finished', 'faye:start'
