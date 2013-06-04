namespace :dj do

  desc "Stop the delayed_job process"
  task :stop, roles: :dj do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job stop"
  end

  desc "Start the delayed_job process"
  task :start, roles: :dj do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job start -n #{delayed_job_workers}"
  end

  desc "Restart the delayed_job process"
  task :restart, roles: :dj do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec script/delayed_job restart -n #{delayed_job_workers}"
  end

  after 'deploy:stop',    'dj:stop'
  after 'deploy:start',   'dj:start'
  after 'deploy:restart', 'dj:restart'

end