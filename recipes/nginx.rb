namespace :nginx do

  desc "Install latest stable release of nginx."
  task :install, roles: :web do
    run "#{sudo} add-apt-repository -y ppa:nginx/stable"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx apache2-utils"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application."
  task :setup, roles: :web do
    template_sudo "nginx_unicorn.erb", "/etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  desc "Start nginx"
  task :start, roles: :web do
    run "#{sudo} service nginx start"
  end

  desc "Stop nginx"
  task :stop, roles: :web do
    run "#{sudo} service nginx stop"
  end

  desc "Restart nginx"
  task :restart, roles: :web do
    run "#{sudo} service nginx restart"
  end

end