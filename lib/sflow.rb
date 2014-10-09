require 'bindata'
require 'eventmachine'
require 'yaml'

dir = File.expand_path(File.join(File.dirname(__FILE__),  'sflow'))
['config','models/ipv4header', 'models/tcpheader', 'models/udpheader', 'models/protocol', 'models/binary_models','parsers/parsers','storage/storage', 'collector','snmp/iface_names'].each do |req|
  require File.join(dir, req)
end

Process.daemon(true) if $daemonize == true
