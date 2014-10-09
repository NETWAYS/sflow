class UDPHeader

  attr_reader :sndr_port,:dist_port,:packet_length,:checksum,
    :data_length,:lower

  def initialize(packet,offset=0,length=nil,lower=nil)
    @packet = packet
    @offset = offset
    header = packet.unpack("x#{offset}n4")
    @sndr_port = header[0]
    @dist_port = header[1]
    @packet_length = header[2]
    @checksum = header[3]
    @data_length = @packet_length - 8
    @lower = lower
  end

  def data
    if(@packet_length>8)
      @packet[@offset+8..@offset+@packet_length]
    else
      ""
    end
  end

  def to_s
    "" <<
    "UDP Header\n" <<
    "  Sender Port     : #{@sndr_port}\n" <<
    "  Distication Port: #{@dist_port}\n" <<
    "  Packet Length   : #{@packet_length}\n" <<
    "  Checksum        : #{@checksum}\n" <<
    "  (Data Length)   : #{@data_length}"
  end
 
end
