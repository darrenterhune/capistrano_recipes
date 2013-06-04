set_default(:mysql_root_password) { Capistrano::CLI.password_prompt "MySQL 'root' Password: " }

namespace :mysql do

  desc "Install mysql"
  task :install, roles: :db, only: { primary: true } do
    run "#{sudo} apt-get -y install mysql-client libmysqlclient-dev mysql-server" do |channel, stream, data|
      channel.send_data("#{mysql_root_password}\n\r") if data =~ /password/
    end
  end
  after "deploy:install", "mysql:install"

  desc "Generate the database and setup user and permissions"
  task :setup, roles: :db do
    DATABASE = YAML::load_file("config/database.yml")[rails_env]
    create_database
    create_mysqluser
    setup_database_permissions
  end
  after "deploy:setup", "mysql:setup"

  desc "Create mysql database"
  task :create_database, role: :db do
    run "mysql -uroot -p#{mysql_root_password} --execute=\"CREATE DATABASE #{application}_#{rails_env};\"" unless database_exists?
  end

  desc "Create mysql user"
  task :create_mysqluser, role: :db do
    run "mysql -uroot -p#{mysql_root_password} --execute=\"CREATE USER '#{application}'@'localhost' IDENTIFIED BY '#{DATABASE['password']}';\"" unless mysqluser_exists?
  end

  desc "Setup permissions for mysql user"
  task :setup_database_permissions, role: :db do
    if mysqluser_exists?
      run "mysql -uroot -p#{mysql_root_password} --execute=\"GRANT ALL PRIVILEGES ON #{application}_#{rails_env} . * TO '#{application}'@'localhost' IDENTIFIED BY '#{DATABASE['password']}';\""
      run "mysql -uroot -p#{mysql_root_password} --execute=\"FLUSH PRIVILEGES\";"
    end
  end

end

def database_exists?
  exists = false
  run "mysql -uroot -p#{mysql_root_password} --execute='SHOW DATABASES';" do |channel, stream, data|
    exists = exists || data.include?("#{application}_#{rails_env}")
  end
  exists
end

def mysqluser_exists?
  exists = false
  run "mysql -uroot -p#{mysql_root_password} --execute=\"SELECT user,host FROM mysql.user WHERE user='#{application}' AND host='localhost';\"" do |channel, stream, data|
    exists = exists || data.include?(application) && data.include?('localhost')
  end
  exists
end