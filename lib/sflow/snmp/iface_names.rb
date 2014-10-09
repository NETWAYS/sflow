class SNMPwalk

  attr_accessor :switchport
  def initialize(switchips)
    print "Getting switch interface names "
    @switchport = {}
      switchips.each do |switchip|
        switch = Resolv.new.getname(switchip).split(/\./)[0]
        ports = {}

        snmpoutput = `snmpwalk -v2c -c public #{switchip} 1.3.6.1.2.1.2.2.1.2`
        snmpoutput.each_line do |line|
           split = line.split(/\s/)
           port = split[0].split(/\./).last
           if split[3] =~ /GigabitEthernet/
             portname = split[3].scan(/\d+/).join('/')
           else
             portname = split[3]
           end
           hashp = { port => portname }
           ports.merge!(hashp)
        end

        hashs = { switch => ports }
        @switchport.merge!(hashs)
        print "."
      end 
    puts " done."
    @switchport
  end

  def self.mapswitchportname(agent_address,iface)
    if $switchportnames.switchport["#{agent_address}"]["#{iface}"]
      $switchportnames.switchport["#{agent_address}"]["#{iface}"]
    else
      agent_address
    end
  end

end
