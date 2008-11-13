require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :graph do
  require "#{File.dirname(__FILE__)}/lib/routing"

  set = Routing::RouteSet.new
  set.draw do |map|
    map.resources :posts
    map.connect ":token/posts.xml", :controller => "posts", :action => "index", :format => "xml"

    map.resources :people

    map.connect 'session', :controller => "sessions", :action => "create", :conditions => { :method => :get }
    map.connect 'login/authenticate', :controller => "sessions", :action => "create", :conditions => { :method => :get }

    map.connect 'login', :controller => "sessions", :action => "new", :conditions => { :method => :get }
    map.resources :session

    map.connect ':controller/:action/:id'
    map.connect ':controller/:action/:id.:format'
  end

  File.open("#{File.dirname(__FILE__)}/tmp/routes.dot", "w") do |f|
    f.write(set.to_graph)
  end

  system("open #{File.dirname(__FILE__)}/tmp/routes.dot")
end
