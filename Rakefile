desc 'Build and package the tb_client extension'
task :compile do
  cd 'ext/tb_client' do
    ruby 'extconf.rb'
    sh 'make clean'
    sh 'make'
    sh 'make install'
  end
end

desc 'Package the tb_client extension'
task package: [:compile] do
  cd 'ext/tb_client' do
    sh 'tar -czf pkg.tar.gz -C ./pkg .'
  end
end
