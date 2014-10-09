#!/usr/bin/env ruby

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..','lib'))

require 'sflow'

SflowCollector.start_collector('0.0.0.0',6343)
