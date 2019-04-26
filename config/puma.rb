workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rack_env = ENV['RACK_ENV'] || 'development'

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment rack_env

ram_total = File.foreach('/proc/meminfo')
              .map {|line| line.match(/MemTotal:\s+(\d+)/)&.captures&.first }
              .compact.first&.to_i

before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.config do |config|
    if ram_total
      config.ram = ram_total / 1024 # mb
      config.frequency = 5 # seconds
      config.percent_usage = 0.90
    end
    config.rolling_restart_frequency = 12 * 3600 # 12 hours
    # setting this to true will log lines like:
    # PumaWorkerKiller: Consuming 54.34765625 mb with master and 2 workers.
    config.reaper_status_logs = rack_env == 'production' ? true : false
  end
  PumaWorkerKiller.start
end

on_worker_boot do
  if ENV['SOFTWARE_O_O_RBTRACE']
    # Trace objects to generate heap dump in production
    puts "Enabling rbtrace and object allocation tracing"
    require 'rbtrace'
    require 'objspace'
    ObjectSpace.trace_object_allocations_start
  end
end

# Instrumentation only when explicitly enabled or when in production
if ENV['INSTRUMENTATION'] == 'true' || ENV['RACK_ENV'] == 'production'
  after_worker_fork do
    require 'prometheus_exporter/instrumentation'
    PrometheusExporter::Instrumentation::Process.start(type:"web")
  end
end
