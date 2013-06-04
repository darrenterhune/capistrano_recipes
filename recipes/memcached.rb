namespace :memcached do

  desc 'Flush memcached server'
  task :flush, roles: :app do
    run "echo 'flush_all' | nc localhost 11211"
  end

end