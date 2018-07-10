# Instrumentation only when explicitly enabled or when in production
if ENV['INSTRUMENTATION'] == 'true' || ENV['RACK_ENV'] == 'production'
  # This reports stats per request like HTTP status and timings
  require 'prometheus_exporter/middleware'
  Rails.application.middleware.unshift PrometheusExporter::Middleware

  # this reports basic process stats like RSS and GC info, type master
  # means it is instrumenting the master process
  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Process.start(type: "master")
end
