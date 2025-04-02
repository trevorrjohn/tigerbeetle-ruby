#!/usr/bin/env ruby
require 'mkmf'

makefile_path = File.join('Makefile')

File.open(makefile_path, 'w') do |f|
  f.puts <<~MFILE
all:
\tenv
\twhich zig
\tzig version
\tpwd
\tcd ./tigerbeetle && zig build clients:c -Dconfig-release=0.16.4 -Dconfig-release-client-min=0.16.4
\tcp -rf ./tigerbeetle/src/clients/c/lib ./pkg
MFILE
end
