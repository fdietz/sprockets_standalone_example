require 'rubygems'
require 'bundler'
Bundler.require

require File.expand_path("../sinatra_app", __FILE__)

map "/assets" do
  run SinatraApp.settings.sprockets_config.sprockets
end

map "/" do
  run SinatraApp
end