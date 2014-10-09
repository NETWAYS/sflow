# Sflow

Tiny sflow collector and parser script based on eventmachine. It listens for sflow v5 samples, parses them and sends it to logstash.

## Installation

Clone this repository

    $ git clone http://github.com/netways/sflow

Change directory

    $ cd sflow

Install dependencies using bundler

    $ bundle install

Configure your logstash endpoint

    $ vi ./etc/config.yaml

And then execute:

    $ bundle exec ./bin/sflow.rb

## Logstash Configuration

A complete logstash installation is a prerequisite.

For getting the parsed sflow-packets as JSON via UDP into logstash you have to configure a input, filter and a output accordingly:

    input {
     udp {
      port => 6543
      type => "sflow"
      codec => 'json'
     }
    }
 
    filter {
     json {
      source => "message"
      type => "json"
     }
    }
 
    output {
     elasticsearch_http {
      workers => 8
      host => "elasticsearch.host"
     }
    }

## Kibana

You can create your very own kibana dashboard for viewing the information and graphs you are interested in. For a quick start you'll find a dashboard in the misc folder, which can be imported via the kibana webinterface.

![Alt text](misc/screen1.png?raw=true "Demo screen")

## Contributing

1. Fork it ( http://github.com/netways/sflow/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
