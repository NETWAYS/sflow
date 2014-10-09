class SflowParser
  require 'ipaddr'
  def self.parse_packet(data)
      header = Header.read(data)
      if header.version == 5 
        agent_address = IPAddr.new(header.agent_address, Socket::AF_INET).to_s
        @sflow = {"agent_address" => $switch_hash[agent_address]}

          header.flow_samples.each do |sample|
            if sample.sflow_sample_type == 3 or sample.sflow_sample_type ==  1
              sampledata = Sflow5sampleheader3.read(sample.sample_data) if sample.sflow_sample_type == 3
              sampledata = Sflow5sampleheader1.read(sample.sample_data) if sample.sflow_sample_type == 1
              sflow_sample = {"sampling_rate" => sampledata.sampling_rate, "i_iface_value" => sampledata.i_iface_value.to_i, "o_iface_value" => sampledata.o_iface_value.to_i}
              @sflow.merge!(sflow_sample)

              sampledata.records.each do |record|
                if record.format == 1001
                  extswitch = Sflow5extswitch.read(record.record_data)
                  sflow_switch = {"vlan_src" => extswitch.src_vlan.to_i, "vlan_dst" => extswitch.dst_vlan.to_i}
                  @sflow.merge!(sflow_switch)
                elsif record.format == 1
                  rawpacket = Sflow5rawpacket.read(record.record_data)
                  if rawpacket.header_protocol == 1 # Ethernet
                    eth_header = Sflow5rawpacketheaderEthernet.read(rawpacket.rawpacket_data.to_ary.join)
                    ip_packet = eth_header.ethernetdata.to_ary.join
                    if eth_header.eth_type == 33024 #VLAN TAG
                      vlan_header = Sflow5rawpacketdataVLAN.read(eth_header.ethernetdata.to_ary.join)
                      ip_packet = vlan_header.vlandata.to_ary.join
                    end
                  end
                  ipv4 = IPv4Header.new(ip_packet)
                  sflow_ip = {"ipv4_src" => ipv4.sndr_addr,"ipv4_dst" => ipv4.dest_addr}
                  @sflow.merge!(sflow_ip)
                  
                  if ipv4.protocol == 6
                    sflow_frame = {"frame_length" => rawpacket.frame_length.to_i, "frame_length_multiplied" => rawpacket.frame_length.to_i * sflow_sample["sampling_rate"].to_i}
                    @sflow.merge!(sflow_frame)
                    header = TCPHeader.new(ipv4.data)
                    sflow_header = {"tcp_src_port" => header.sndr_port.to_i, "tcp_dst_port" => header.dest_port.to_i}
                    @sflow.merge!(sflow_header)
                  elsif ipv4.protocol == 17
                    header = UDPHeader.new(ipv4.data)
                    sflow_header = {"udp_src_port" => header.sndr_port.to_i, "udp_dst_port" => header.dist_port.to_i}
                    @sflow.merge!(sflow_header)
                  end

                end
              end

            elsif sample.sflow_sample_type == 4 or sample.sflow_sample_type == 2
              sampledata = Sflow5counterheader4.read(sample.sample_data) if sample.sflow_sample_type == 4
              sampledata = Sflow5counterheader2.read(sample.sample_data) if sample.sflow_sample_type == 2
              sampledata.records.each do |record|
                if record.format == 1
                  generic_int_counter = Sflow5genericcounter.read(record.record_data)
                  sflow_counter = {"i_octets" => generic_int_counter.input_octets.to_i, "o_octets" => generic_int_counter.output_octets.to_i, "interface" => generic_int_counter.int_index.to_i, "input_packets_error" => generic_int_counter.input_packets_error.to_i, "output_packets_error" => generic_int_counter.output_packets_error.to_i}
                  @sflow.merge!(sflow_counter)
                elsif record.format == 2
                  eth_int_counter = Sflow5ethcounter.read(record.record_data)
                  @sflow
                end
              end
            end
          end 
      end
      return @sflow
  end
end
