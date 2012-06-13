require "bundler/capistrano"

server "68.233.230.20", :web, :app, :db, primary: true

set :application, "uncom"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"

# Avoid full repository clone every time. Remote caching will keep a local git repo on the server.
# It will only fetch the changes.
set :deploy_via, :remote_cache

set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:billytruong2001/#{application}.git"
set :branch, "master"


# Must be set for the password prompt from git to work
default_run_options[:pty] = true

# The deploy user's password
#set :scm_passphrase, "p@ssw0rd"  

# If you're using your own private keys for git, you want to tell Capistrano 
# to use agent forwarding with this command. it uses your local keys instead of 
# keys installed on the server.
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do

  task :setup_config, roles: :app do
    #sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    #sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    #run "mkdir -p #{shared_path}/config"
    #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    
    sudo "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    sudo "ln -nfs #{shared_path}/log/production.log #{current_path}/log/production.log"
    run "touch #{current_path}/tmp/restart.txt"

    puts "Just linked database file to current config dir."
  end
  after "deploy:setup", "deploy:setup_config"

  %w[start stop restart].each do |command|
    desc "#{command} apache server"
    task command, roles: :app, except: {no_release: true} do
      run "#{sudo} /etc/init.d/apache2 #{command}"
    end
    
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end