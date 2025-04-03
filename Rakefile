task :compile do
  cd 'ext/tb_client' do
    ruby 'extconf.rb'
    sh 'make'
  end
end

task package: [:compile] do
  cd 'ext/tb_client' do
    sh 'tar -czf pkg.tar.gz -C ./pkg .'
  end
end
