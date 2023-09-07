# Note: this file is meant to launch unicorn on development
# `unicorn -c config/unicorn.rb -p 9009`

worker_processes 3
timeout 900

ENV['UNICORN_MEMORY_MIN'] = (350*(1024**2)).to_s
ENV['UNICORN_MEMORY_MAX'] = (900*(1024**2)).to_s

preload_app true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = Rails.root.join("Gemfile").to_s
end

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    begin
      ActiveRecord::Base.connection.disconnect!
    rescue ActiveRecord::ConnectionNotEstablished
      nil
    end
  end

  if defined?(Redis) && defined?(Redis.current)
    Redis.current.quit
  end

  old_pid = "#{server.config['pid']}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(Redis) && Redis.respond_to?(:connect_current)
    Redis.connect_current
  end
end