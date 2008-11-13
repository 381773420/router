Map = Proc.new do |map|
  map.resources :posts

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

require "#{File.dirname(__FILE__)}/../lib/routing"
Routing::Routes.draw(&Map)

require 'rubygems'
require 'action_controller'

ActionController::Routes = ActionController::Routing::RouteSet.new
ActionController::Routes.draw(&Map)

require 'benchmark'

TIMES = 10000
Benchmark.bmbm do |x|
  x.report("Routing::Routes")          { TIMES.times { Routing::Routes.recognize_path("GET", "/posts") } }
  x.report("ActionController::Routes") { TIMES.times { ActionController::Routes.recognize_path("/posts", :method => :get) } }
end
