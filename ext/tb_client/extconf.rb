#!/usr/bin/env ruby
require 'mkmf'

makefile_path = File.join('Makefile')
client_version = '0.16.34'
tar_package = 'pkg.tar.gz'

makefile = ''

puts ENV.each { |k, v| puts "#{k}=#{v}" }
if find_executable('zig') && File.exist?('./tigerbeetle/build.zig')
  makefile = <<~MFILE
    all:
    \techo "Compiling native TB client from the source"
    \tzig version
    \tcd ./tigerbeetle && zig build clients:c -Dconfig-release=#{client_version} -Dconfig-release-client-min=#{client_version}
    \n\n
    install:
    \tcp -rf ./tigerbeetle/src/clients/c/lib ./pkg
    \n\n
    clean:
    \trm -rf ./tigerbeetle/src/clients/c/lib
  MFILE
elsif File.exist?("./#{tar_package}")
  makefile = <<~MFILE
    all:
    \tmkdir pkg
    \ttar -xzf #{tar_package} -C ./pkg
    \n\n
    install:
    \techo "Installing precompiled native TB client"
    \n\n
    clean:
    \techo "Nothing to clean"
  MFILE
end

File.open(makefile_path, 'w') do |f|
  f.puts makefile
end
