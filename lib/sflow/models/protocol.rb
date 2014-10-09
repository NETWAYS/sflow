require_relative 'ipv4header'
require_relative 'udpheader'
require_relative 'tcpheader'

class Protocol
  ICMP = 0x01
  IGMP = 0x02
  TCP  = 0x06
  UDP  = 0x11
  IPv6 = 0x29

  def self.to_class protocol
    case protocol
    when Protocol::ICMP
      raise "ICMP is not supported"
    when Protocol::IGMP
      raise "IGMP is not supported"
    when Protocol::TCP
      TCPHeader
    when Protocol::UDP
      UDPHeader
    when Protocol::IPv6
      raise "IPv6 is not supported"
    else
      raise "Protocol:"+sprintf("0x%2X",protocol)+" is not supported"
    end
  end
 
  def self.to_s protocol
    case protocol
    when Protocol::ICMP
      "ICMP"
    when Protocol::IGMP
      "IGMP"
    when Protocol::TCP
      "TCP"
    when Protocol::UDP
      "UDP"
    when Protocol::IPv6
      "IPv6"
    else
      sprintf("0x%2X",protocol)
    end
  end

end

