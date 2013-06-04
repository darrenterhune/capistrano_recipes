set_default(:postfix_email, "tech@aircraftsalesandparts.net")

namespace :postfix do

  desc "Install postfix mailserver."
  task :install, roles: :web do
    run "#{sudo} DEBCONF_TERSE='yes' DEBIAN_PRIORITY='critical' DEBIAN_FRONTEND=noninteractive apt-get -qyu --force-yes -y install postfix"
  end
  after "deploy:install", "postfix:install"

  desc "Setup posfix configuration for this application."
  task :setup, roles: :web do
    run "#{sudo} service postfix restart"
  end
  after "deploy:setup", "postfix:setup"

end