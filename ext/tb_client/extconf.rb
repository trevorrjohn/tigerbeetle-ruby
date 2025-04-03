#!/usr/bin/env ruby
require 'mkmf'

makefile_path = File.join('Makefile')
client_version = '0.16.34'

File.open(makefile_path, 'w') do |f|
  f.puts <<~MFILE
all:
\tzig version
\tcd ./tigerbeetle && zig build clients:c -Dconfig-release=#{client_version} -Dconfig-release-client-min=#{client_version}
\tcp -rf ./tigerbeetle/src/clients/c/lib ./pkg
MFILE
end
