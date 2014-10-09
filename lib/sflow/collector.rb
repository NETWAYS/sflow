class SflowCollector
  module Collector
  Thread.abort_on_exception=true
  require 'socket'
    def post_init
      puts "Server listening."
    end

    def receive_data(data)
      operation = proc do
        begin
          if data != nil
            sflow = SflowParser.parse_packet(data)
          end
        rescue Exception => e
          puts Time.now
          puts sflow.inspect
          puts e.message
          puts e.backtrace
        end
      end

      callback = proc do |sflow|
        begin
          if sflow != nil
            SflowStorage.send_udpjson(sflow)
          end
        rescue Exception => e
          puts Time.now
          puts sflow.inspect if sflow != nil
          puts e.message
          puts e.backtrace
        end
      end

      EM.defer(operation,callback)

    end
  end

  def self.start_collector(bind_ip = '0.0.0.0', bind_port = 6343)
    begin
      config = SflowConfig.new
      if config.logstash_host and config.logstash_port 
        puts "Connecting to Logstash: #{config.logstash_host}:#{config.logstash_port}"
        $logstash = UDPSocket.new
        $logstash.connect(config.logstash_host, config.logstash_port)
      else
        puts "no host:port given"
        exit 1
      end
      $switch_hash = config.switch_hash
      if config.switch_hash != nil
        $switchportnames = SNMPwalk.new(config.switch_hash.each_key)
      end
      EventMachine::run do
        EventMachine::open_datagram_socket(bind_ip, bind_port, Collector)
      end
    rescue Exception => e
      puts Time.now
      puts e.message
      puts e.backtrace
      raise "unable to start sflow collector"
    end
  end

end


