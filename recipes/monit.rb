namespace :monit do

  desc 'Install Monit'
  task :install do
    run "#{sudo} apt-get -y install monit"
  end
  after 'deploy:install', 'monit:install'

  task(:nginx, roles: :web) { monit_config 'nginx' }
  task(:mysql, roles: :db) { monit_config 'mysql' }
  task(:unicorn, roles: :app) { monit_config 'unicorn' }
  task(:sphinx, roles: :app) { monit_config 'sphinx' }
  task(:memcached, roles: :app) { monit_config 'memcached' }
  task(:delayed_job, roles: :app) { monit_config 'dj' }

  desc 'Setup all Monit configuration'
  task :setup do
    template_sudo "monitrc.erb", "/etc/monit/monitrc"
    run "#{sudo} chown root /etc/monit/monitrc"
    run "#{sudo} chmod 0700 /etc/monit/monitrc"
    nginx
    mysql
    unicorn
    sphinx
    memcached
    delayed_job
    syntax
    reload
  end
  after 'deploy:setup', 'monit:setup'

  desc 'Run Monit start script'
  task :start do
    run "#{sudo} service monit start"
  end

  desc 'Run Monit stop script'
  task :stop do
    run "#{sudo} service monit stop"
  end

  desc 'Run Monit restart script'
  task :restart do
    run "#{sudo} service monit restart"
  end

  desc 'Run Monit syntax script'
  task :syntax do
    run "#{sudo} service monit syntax"
  end

  desc 'Run Monit reload script'
  task :reload do
    run "#{sudo} service monit reload"
  end

end