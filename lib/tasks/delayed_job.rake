require 'workers/search_helper_job.rb'

task(:clean_stats => :environment) do
  desc "Inject a job to clean up the search cache"
  task(:searchhelper => :environment) { Delayed::Job.enqueue SearchHelperJob.new }

end

