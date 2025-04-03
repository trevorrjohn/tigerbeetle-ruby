#!/usr/bin/env ruby
require 'mkmf'

makefile_path = File.join('Makefile')
client_version = '0.16.34'
tar_package = 'pkg.tar.gz'

makefile = ''

if find_executable('zig') && File.exist?('./tigerbeetle/build.zig')
  makefile = <<~MFILE
    all:
    \tzig version
    \tcd ./tigerbeetle && zig build clients:c -Dconfig-release=#{client_version} -Dconfig-release-client-min=#{client_version}
    \tcp -rf ./tigerbeetle/src/clients/c/lib ./pkg
  MFILE
elsif File.exist?("./#{tar_package}")
  makefile = <<~MFILE
    all:
    \tmkdir pkg
    \ttar -xzf #{tar_package} -C ./pkg
  MFILE
end

File.open(makefile_path, 'w') do |f|
  f.puts makefile
end
