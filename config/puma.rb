workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  if ENV['SOFTWARE_O_O_RBTRACE']
    # Trace objects to generate heap dump in production
    puts "Enabling rbtrace and object allocation tracing"
    require 'rbtrace'
    require 'objspace'
    ObjectSpace.trace_object_allocations_start
  end
end

if Rails.env.production?
  after_worker_fork do
    require 'prometheus_exporter'
    require 'prometheus_exporter/instrumentation' # todo needed?
    PrometheusExporter::Instrumentation::Process.start(type:"web")
  end
end

