require 'net/smtp'

set :application, "software"

# git settings
set :scm, :git
set :repository,  "git://gitorious.org/opensuse/software-o-o.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :migrate_target, :current

set :deploy_notification_to, ['tschmidt@suse.de', 'coolo@suse.de']
server "buildserviceapi.suse.de", :app, :web, :db, :primary => true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/www/vhosts/opensuse.org/#{application}"

# set variables for different target deployments
task :stage do
  set :deploy_to, "/srv/www/vhosts/opensuse.org/stage/#{application}"
  set :runit_name, "software_stage"
  set :branch, "derivates"
end


ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :normalize_asset_timestamps, false

# tasks are run with this user
set :user, "root"
# spinner is run with this user
set :runner, "root"

after "deploy:update_code", "config:symlink_shared_config"
after "deploy:symlink", "config:permissions"
after "deploy:finalize_update", "deploy:notify"

after :deploy, 'deploy:cleanup' # only keep 5 releases


namespace :config do

  desc "Install saved configs from /shared/ dir"
  task :symlink_shared_config do
    run "rm #{release_path}/config/environments/production.rb"
    run "ln -s #{shared_path}/production.rb #{release_path}/config/environments/"
    run "rm -f #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "rm -f #{release_path}/config/options.yml"
    run "ln -s #{shared_path}/options.yml #{release_path}/config/options.yml"
    run "rm -r #{release_path}/tmp/cache"
    run "ln -s #{shared_path}/software.o.o.cache #{release_path}/tmp/cache"
  end

  desc "Set permissions"
  task :permissions do
    run "chown -R lighttpd #{current_path}/db #{current_path}/tmp #{current_path}/tmp/cache/ #{current_path}/log #{current_path}/public"
  end
end

# server restarting
namespace :deploy do
  task :start do
    run "sv start /service/software-*"
  end

  task :restart do
    run "sv 1 /service/software-*"
  end

  task :stop do
    run "sv stop /service/software-*"
  end


  desc "Send email notification of deployment"
  task :notify do
    #diff = `#{source.local.diff(current_revision)}`
    begin
      diff_log = `#{source.local.log( source.next_revision(current_revision) )}`
    rescue
      diff_log = "No REVISION found, probably initial deployment."
    end
    user = `whoami`
    body = %Q[From: software-deploy@suse.de
To: #{deploy_notification_to.join(", ")}
Subject: software deployed by #{user}

Git log:
#{diff_log}]

    Net::SMTP.start('relay.suse.de', 25) do |smtp|
      smtp.send_message body, 'software-deploy@suse.de', deploy_notification_to
    end
  end
  
end


