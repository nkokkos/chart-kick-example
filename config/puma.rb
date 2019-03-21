# This goes in the app as config/puma.rb

environment 'development'
workers 1
threads 1,4
preload_app!
daemonize true
pidfile 'tmp/pids/puma.pid'
stdout_redirect 'log/puma.log', 'log/puma.log', true

bind 'unix://tmp/sockets/puma.sock'
state_path 'tmp/pids/puma.state'

on_worker_boot do |worker_index|

  # write worker pid
  File.open("tmp/pids/puma_worker_#{worker_index}.pid", "w") { |f| f.puts Process.pid }

  # reconnect to redis
  # Redis.current.client.reconnect

  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
