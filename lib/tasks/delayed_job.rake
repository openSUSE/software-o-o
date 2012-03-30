require 'workers/search_helper_job.rb'

namespace :jobs do
  desc "Inject a job to update the 'most downloaded packages' cache"
  task(:searchhelper => :environment) { Delayed::Job.enqueue SearchHelperJob.new }
end

desc "Update the 'most downloaded packages' cache"
task(:update_download_stats => :environment) do
  SearchHelperJob.new.perform
end


