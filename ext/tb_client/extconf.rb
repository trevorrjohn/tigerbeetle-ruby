#!/usr/bin/env ruby
require 'mkmf'

makefile_path = File.join('Makefile')

File.open(makefile_path, 'w') do |f|
  f.puts <<~MFILE
all:
\tcd ./tigerbeetle && zig build clients:c -Dconfig-release=0.16.26 -Dconfig-release-client-min=0.16.26
\tcp -r ./tigerbeetle/src/clients/c/lib ./pkg
MFILE
end
