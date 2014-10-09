class TCPHeader

  attr_reader :sndr_port,:dest_port,:seq_num,:ack_num,:header_length,
    :urg,:ack,:psh,:rst,:syn,:fin,:win_size,:checksum,:emgcy_ptr,
    :packet_length,:data_length,:lower

  def initialize(packet,offset=0,length=nil,lower=nil)
    @packet = packet.force_encoding("ASCII-8BIT")
    @offset = offset
    @length = length || packet.bytesize-offset
    header = packet.unpack("x#{offset}n2N2n4")
    @sndr_port = header[0]
    @dest_port = header[1]
    @seq_num = header[2]
    @ack_num = header[3]
    @header_length = (header[4]>>12)*4
    @urg = (header[4] & 0b100000) != 0
    @ack = (header[4] & 0b010000) != 0
    @psh = (header[4] & 0b001000) != 0
    @rst = (header[4] & 0b000100) != 0
    @syn = (header[4] & 0b000010) != 0
    @fin = (header[4] & 0b000001) != 0
    @win_size = header[5]
    @checksum = header[6]
    @emgcy_ptr = header[7]

    @packet_length = @length
    @data_length = @packet_length-@header_length

    @lower = lower

    # check checksum
    calc_cs = false
    if calc_cs
    tmp =  @packet[@offset..@offset+@length]
    if (tmp.length % 2) != 0
      tmp += "\0"
    end
    data = @lower.get_virtual_header + tmp
    sum = 0
    list = data.unpack("n*")
    list.each do |d|
      sum += d
    end
    sum  = (sum & 0xffff) + (sum >> 16)
    sum  = (sum & 0xffff) + (sum >> 16)
    raise if sum != 65535
    end




  end

  def data
    if(@data_length>0)
      @packet[@offset+@header_length..@offset+@length]
    else
      ""
    end
  end

  def to_s
    "TCP Header\n" <<
    "  Sender Port     : #{@sndr_port}\n" <<
    "  Destination Port: #{@dest_port}\n" <<
    "  Sequence Number : #{@seq_num}\n" <<
    "  ACK Number      : #{@ack_num}\n" <<
    "  Header Length   : #{@header_length}\n" <<
    "  URG             : #{@urg}\n" <<
    "  ACK             : #{@ack}\n" <<
    "  PSH             : #{@psh}\n" <<
    "  RST             : #{@rst}\n" <<
    "  SYN             : #{@syn}\n" <<
    "  FIN             : #{@fin}\n" <<
    "  Window Size     : #{@win_size}\n" <<
    "  Checksum        : #{@checksum}\n" <<
    "  Emergency Ptr   : #{@emgcy_ptr}\n" <<
    "  (Packet Length) : #{@packet_length}\n" <<
    "  (Data Length)   : #{@data_length}"
  end
end
