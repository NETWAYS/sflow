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

## Contributing

1. Fork it ( http://github.com/netways/sflow/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
