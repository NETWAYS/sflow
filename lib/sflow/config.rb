class SflowConfig
  attr_reader :switch_hash
  attr_reader :logstash_host
  attr_reader :logstash_port
  attr_reader :daemonize

  def initialize
    config = YAML.load_file("etc/config.yaml")
    @switch_hash = config['switch']
    @logstash_host = config['logstash_host']
    @logstash_port = config['logstash_port']
    @daemonize = config['daemonize']
  end
end

