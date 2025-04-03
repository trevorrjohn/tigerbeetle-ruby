#!/usr/bin/env ruby
require 'mkmf'

client_version = '0.16.34'
tar_package = 'pkg.tar.gz'

if find_executable('zig') && File.exist?('./tigerbeetle/build.zig')
  File.open(File.join('Makefile'), 'w') do |f|
    f.puts <<~MFILE
      .PHONY = all install clean
      \n\n
      all:
      \techo "Compiling native TB client from the source"
      \tzig version
      \tcd ./tigerbeetle && zig build clients:c -Dconfig-release=#{client_version} -Dconfig-release-client-min=#{client_version}
      \n\n
      install:
      \tcp -rf ./tigerbeetle/src/clients/c/lib ./pkg
      \n\n
      clean:
      \trm -rf ./pkg/
      \trm -rf ./tigerbeetle/src/clients/c/lib
    MFILE
  end
elsif File.exist?("./#{tar_package}")
  `mkdir pkg && tar -xzf #{tar_package} -C ./pkg`
end
