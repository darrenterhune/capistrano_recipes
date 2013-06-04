namespace :shared_config do

  desc "Upload shared_config files"
  task :upload do
    run "mkdir -p #{shared_path}/ssl"
    run "mkdir -p #{shared_path}/config"
    run "#{sudo} chown -R #{user} #{deploy_to}"
    upload_files
    upload_certificates
  end

  desc "Symlink shared_config yml files"
  task :symlink, roles: :app do
    SETUP_CONFIG['shared_config'].each do |file|
      run "ln -sf #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end

end

after 'deploy:setup', 'shared_config:upload'
after 'deploy:update_code', 'shared_config:symlink'

def upload_files
  SETUP_CONFIG['shared_config'].each do |file|
    filename = "#{File.expand_path('../../', __FILE__)}/#{file}"
    upload(filename, "#{shared_path}/config/#{file}", via: :scp)
  end
end

def upload_certificates
  bundle = "#{File.expand_path('../../ssl', __FILE__)}/ssl-bundle.crt"
  upload(bundle, "#{shared_path}/ssl/ssl-bundle.crt", via: :scp)

  certificate = "#{File.expand_path('../../ssl', __FILE__)}/certificate.crt"
  upload(certificate, "#{shared_path}/ssl/certificate.crt", via: :scp)

  key = "#{File.expand_path('../../ssl', __FILE__)}/certificate.key"
  upload(key, "#{shared_path}/ssl/certificate.key", via: :scp)

  run "#{sudo} chown root #{shared_path}/ssl/certificate.key"
  run "#{sudo} chmod 600 #{shared_path}/ssl/certificate.key"
end