class SflowStorage
  require 'json'

  def self.send_udpjson(sflow)

  #remap hash-keys with prefix "sflow_"
      mappings = {"agent_address" => "sflow_agent_address",
                  "sampling_rate" => "sflow_sampling_rate",
                  "i_iface_value" => "sflow_i_iface_value",
                  "o_iface_value" => "sflow_o_iface_value",
                  "vlan_src" => "sflow_vlan_src",
                  "vlan_dst" => "sflow_vlan_dst",
                  "ipv4_src" => "sflow_ipv4_src",
                  "ipv4_dst" => "sflow_ipv4_dst",
                  "frame_length" => "sflow_frame_length",
                  "frame_length_multiplied" => "sflow_frame_length_multiplied",
                  "tcp_src_port" => "sflow_tcp_src_port",
                  "tcp_dst_port" => "sflow_tcp_dst_port"
      }

      prefixed_sflow = Hash[sflow.map {|k, v| [mappings[k], v] }]

      if sflow['i_iface_value'] and sflow['o_iface_value']
        i_iface_name = {"sflow_i_iface_name" => SNMPwalk.mapswitchportname(sflow['agent_address'],sflow['i_iface_value'])}
        o_iface_name = {"sflow_o_iface_name" => SNMPwalk.mapswitchportname(sflow['agent_address'],sflow['o_iface_value'])}
        prefixed_sflow.merge!(i_iface_name)
        prefixed_sflow.merge!(o_iface_name)
      end

      $logstash.send(prefixed_sflow.to_json, 0)

  end

end
