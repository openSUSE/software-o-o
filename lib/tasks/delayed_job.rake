require 'workers/search_helper_job.rb'

namespace :jobs do
 desc "Inject a job to update the search cache"
 task(:searchhelper => :environment) { Delayed::Job.enqueue SearchHelperJob.new }
end

