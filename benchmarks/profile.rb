require 'rubygems'
require 'ruby-prof'

def gc_statistics(description = "", options = {})
  raise unless GC.respond_to? :enable_stats

  GC.enable_stats || GC.clear_stats
  GC.disable

  yield

  stat_string = "allocated: #{GC.allocated_size/1024}K total in #{GC.num_allocations} allocations, "
  stat_string += "GC calls: #{GC.collections}, "
  stat_string += "GC time: #{GC.time / 1000} msec"

  GC.log stat_string

  GC.enable
  GC.disable_stats
end

Map = Proc.new do |map|
  map.resources :posts

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

require "#{File.dirname(__FILE__)}/../lib/routing"
Routing::Routes.draw(&Map)

# gc_statistics do
#   Routing::Routes.recognize_path("GET", "/posts/1/edit")
# end

result = RubyProf.profile do
  Routing::Routes.recognize_path("GET", "/posts/1/edit")
end

printer = RubyProf::FlatPrinter.new(result)
# printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(STDOUT, 0)
