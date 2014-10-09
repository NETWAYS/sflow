class Header < BinData::Record
  endian :big
  uint32 :version
  uint32 :address_type
  uint32 :agent_address
  uint32 :sub_agent_id
  uint32 :seq_number
  uint32 :sys_uptime
  uint32 :num_samples
  array :flow_samples, :initial_length => :num_samples do
    uint16 :enterprise_std
    uint16 :sflow_sample_type
    uint32 :sample_length
    string :sample_data, :length => :sample_length
  end
end

class Sflow5sampleheader1 < BinData::Record
  endian :big
  uint32 :seq_number
  uint32 :source_id_type
  uint32 :sampling_rate
  uint32 :sample_pool
  uint32 :dropped_packets
  uint32 :i_iface_value
  uint32 :o_iface_value
  uint32 :num_records
  array :records, :initial_length => :num_records do
    uint16 :enterprise
    uint16 :format
    uint32 :flow_length
    string :record_data, :length => :flow_length
  end

end

class Sflow5sampleheader3 < BinData::Record
  endian :big
  uint32 :seq_number
  uint32 :source_id_type
  uint32 :source_id_index
  uint32 :sampling_rate
  uint32 :sample_pool
  uint32 :dropped_packets
  uint32 :i_iface_format
  uint32 :i_iface_value
  uint32 :o_iface_format
  uint32 :o_iface_value
  uint32 :num_records
  array :records, :initial_length => :num_records do
    uint16 :enterprise
    uint16 :format
    uint32 :flow_length
    string :record_data, :length => :flow_length
  end

end


class Sflow5counterheader4 < BinData::Record
  endian :big
  uint32 :seq_number
  uint32 :source_id_type
  uint32 :source_id_index
  uint32 :num_records
  array :records, :initial_length => :num_records do
    uint16 :enterprise
    uint16 :format
    uint32 :record_length
    string :record_data, :length => :record_length
  end
end

class Sflow5counterheader2 < BinData::Record
  endian :big
  uint32 :seq_number
  uint32 :source_id_type
  uint32 :num_records
  array :records, :initial_length => :num_records do
    uint16 :enterprise
    uint16 :format
    uint32 :record_length
    string :record_data, :length => :record_length
  end
end


class Sflow5rawpacket < BinData::Record 
  endian :big
  uint32 :header_protocol
  uint32 :frame_length
  uint32 :payload
  uint32 :xy
  array :rawpacket_data, :read_until => :eof do
    string :data, :length => 1
  end
end

class Sflow5extswitch < BinData::Record
  endian :big
  uint32 :src_vlan
  uint32 :src_priority
  uint32 :dst_vlan
  uint32 :dst_priority
end

class Sflow5genericcounter < BinData::Record
  endian :big
  uint32 :int_index
  uint32 :int_type
  uint64 :int_speed
  uint32 :int_direction
  uint16 :int_admin_status
  uint16 :int_oper_status
  uint64 :input_octets
  uint32 :input_packets
  uint32 :input_packets_multi
  uint32 :input_packets_broad
  uint32 :input_packets_discard
  uint32 :input_packets_error
  uint32 :unknown_proto
  uint64 :output_octets
  uint32 :output_packets
  uint32 :output_packets_multi
  uint32 :output_packets_broad
  uint32 :output_packets_discard
  uint32 :output_packets_error
  uint32 :prom_mode
end

class Sflow5ethcounter < BinData::Record
  endian :big
  uint32 :alignment_errors
  uint32 :fcs_errors
  uint32 :single_collision_frames
  uint32 :multi_collision_frames
  uint32 :sqe_test_errors
  uint32 :deffered_transmission
  uint32 :late_collision
  uint32 :excessive_collision
  uint32 :internal_mac_transmit_errors
  uint32 :carrier_sense_errors
  uint32 :frame_too_long
  uint32 :internal_mac_receive_errors
  uint32 :symbol_errors
end

class Sflow5rawpacketheaderEthernet < BinData::Record
  endian :big
  string :eth_src, :length => 6
  string :eth_dst, :length => 6
  uint16 :eth_type
  array :ethernetdata, :read_until => :eof do
    string :data, :length => 1
  end
end

class Sflow5rawpacketdata < BinData::Record
  endian :big
  string :eth, :length => 14
  string :vlan_tag, :length => 2
  string :vlan_tag_p, :length => 2
  string :vlana, :length => 2
  string :vlanb, :length => 2
  string :ip_packet, :length => 40
end

class Sflow5rawpacketdataVLAN < BinData::Record
  endian :big
  uint16 :prio
  uint16 :type
  array :vlandata, :read_until => :eof do
    string :data, :length => 1
  end
end

