$:.unshift File.dirname(__FILE__)

require File.dirname(__FILE__) + '/../ext/router_ext'

require 'routing/segments'
require 'routing/named_route_collection'
require 'routing/route_set'
