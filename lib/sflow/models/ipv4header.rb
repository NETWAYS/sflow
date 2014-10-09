# coding: utf-8
require_relative 'protocol'

# TODO: チェックサムを確認する
class IPv4Header

  attr_reader :version,:header_length,:packet_length,:identification,:frag_dont,:frag_more,:frag_offset,:ttl,:protocol,:checksum,:sndr_addr,:dest_addr,
    :data_length

  def initialize(packet,offset=0)
    @packet = packet.force_encoding("ASCII-8BIT")
    @offset = offset
    header = packet.unpack("x#{offset}n10")
    @version = header[0] >> 12
    @header_length  = ((header[0] >> 8) & 0x0f)*4
    @packet_length = header[1]
    @identification = header[2]
    @frag_dont = (header[3] >> 14) & 0x01 != 0
    @frag_more  = (header[3] >> 13) & 0x01 != 0
    @frag_offset = header[3] & 0x1fff
    @ttl = header[4] >> 8
    @protocol = header[4] & 0x00ff
    @checksum = header[5]
    @sndr_addr = ip_to_s(packet[12..15])
    @dest_addr = ip_to_s(packet[16..19])
    @data_length = @packet_length - @header_length

    @virtual_header = packet[12..19] + [0,6,@data_length].pack("CCn")

  end

  def upper
    upper_header = Protocol.to_class(@protocol)
    offset = @offset+@header_length
    upper_header.new(@packet,offset,@data_length,self)
  end
  
  def data
    start = @offset+@header_length
    @packet[start..start+@data_length]
  end

  def get_virtual_header
    @virtual_header
  end

  def ip_to_s(ip)
    ip = ip.unpack("n2")
    sprintf("%d.%d.%d.%d",ip[0]>>8,ip[0]&0x00ff,ip[1]>>8,ip[1]&0x00ff)
  end

  def to_s
    "IPv4 Header\n" <<
    "  Version            : #{@version}\n" <<
    "  Header Length      : #{@header_length}\n" <<
    "  Packet Length      : #{@packet_length}\n" <<
    "  Identification     : #{@identification}\n" <<
    "  Don't fragment     : #{@frag_dont}\n" <<
    "  More fragments     : #{@frag_more}\n" <<
    "  Fragment Offset    : #{@frag_offset}\n" <<
    "  TTL                : #{@ttl}\n" <<
    "  Protocol           : #{Protocol.to_s(@protocol)}\n" <<
    "  Header Checksum    : #{@checksum}\n" <<
    "  Sender Address     : #{@sndr_addr}\n" <<
    "  Destination Address: #{@dest_addr}\n" <<
    "  (Data Length)      : #{@data_length}"
  end

end
