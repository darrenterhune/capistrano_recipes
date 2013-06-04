SETUP_CONFIG = YAML::load_file(File.expand_path('../../setup_config.yml', __FILE__))

namespace :deploy do

  # Base setup and package installs that don't require configurations
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties software-properties-common dialog curl wget imagemagick memcached build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev libgdbm-dev ncurses-dev automake libtool bison subversion pkg-config libffi-dev libssl-dev"
  end

  desc 'Warnings on install before setup'
  task :warning, role: :web do
    puts "\n\n"
    puts "IMPORTANT!!!!!"
    puts "\n"
    puts "Setup http auth if staging: https://www.digitalocean.com/community/articles/how-to-set-up-http-authentication-with-nginx-on-ubuntu-12-10"
    puts "Mysql setup: sudo /usr/bin/mysql_secure_installation before cap deploy:setup"
    puts "\n\n"
  end

end

def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def template_sudo(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put_sudo ERB.new(erb).result(binding), to
end

def put_sudo(data, to)
  filename = File.basename(to)
  to_directory = File.dirname(to)
  put data, "/tmp/#{filename}"
  run "#{sudo} mv /tmp/#{filename} #{to_directory}"
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template_sudo "monit_#{name}.erb", destination
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end