require 'net/smtp'

set :application, "software"

# git settings
set :scm, :git
set :repository,  "git://github.com/openSUSE/software-o-o.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :migrate_target, :current
set :use_sudo, false

set :deploy_notification_to, ['tschmidt@suse.de', 'coolo@suse.de']
server "software", :app, :web, :db, :primary => true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/srv/www/vhosts/opensuse.org/#{application}"
set :static, "software.o.o"

# set variables for different target deployments
task :stage do
  set :deploy_to, "/srv/www/vhosts/opensuse.org/stage/#{application}"
  set :branch, "master"
  set :static, "software.o.o-stage/stage"
end


ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :normalize_asset_timestamps, false

# tasks are run with this user
set :user, "root"
# spinner is run with this user
set :runner, "root"

after "deploy:update_code", "config:symlink_shared_config"
after "deploy:update_code", "config:sync_static"
after "deploy:create_symlink", "config:permissions"
after "deploy:restart", "deploy:notify"

after :deploy, 'deploy:cleanup' # only keep 5 releases

io = IO.popen('BUNDLE_FROZEN=1 BUNDLE_WITHOUT=test:development bundle show --paths | sed -e "s,.*/,,; s,^,rubygem(1.9.1:,; s,-\([^-]*\)$,) = \1,"')
zypperlines = io.readlines
 
begin
  diff_log = `#{source.local.log( source.next_revision(current_revision), branch )}`
rescue
  diff_log = "No REVISION found, probably initial deployment."
end

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
    run "cd #{release_path}; zypper ref"
    run "cd #{release_path}; zypper -n in -C \"#{zypperlines.join('" "')}\""
    run "cd #{release_path}; bundle config --local frozen 1; bundle config --local without test:development"
    run "cd #{release_path}; bundle show"
    run "cd #{release_path}; bundle exec rake assets:precompile RAILS_ENV=production --trace"
  end

  desc "Set permissions"
  task :permissions do
    run "chown -R soorun #{current_path}/db #{current_path}/tmp #{current_path}/tmp/cache/ #{current_path}/log #{current_path}/public"
  end

  desc "Sync public to static.o.o"
  task :sync_static do
    `rsync  --delete-after --exclude=themes -av --no-p public/ -e 'ssh -p2212' proxy-opensuse.suse.de:/srv/www/vhosts/static.opensuse.org/hosts/#{static}`
    # Secondary (high-availability) VM for static needs the same content
    `rsync  --delete-after --exclude=themes -av --no-p public/ -e 'ssh -p2213' proxy-opensuse.suse.de:/srv/www/vhosts/static.opensuse.org/hosts/#{static}`
  end
end

# server restarting
namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
    run "sv restart /etc/service/delayed_job_software"
  end


  desc "Send email notification of deployment"
  task :notify do
    #diff = `#{source.local.diff(current_revision)}`
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


