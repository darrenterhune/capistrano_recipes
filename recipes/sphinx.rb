namespace :sphinx do

  desc "Install sphinx"
  task :install, roles: :web do
    run "#{sudo} apt-get -y install sphinxsearch"
  end
  after "deploy:install", "sphinx:install"

  desc "Setup sphinx init.d configuration for this application."
  task :setup, roles: :web do
    template_sudo "sphinx.init.erb", "/etc/init.d/searchd"
    run "#{sudo} chmod +x /etc/init.d/searchd"
  end
  after "deploy:setup", "sphinx:setup"

end