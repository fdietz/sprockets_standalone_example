require 'rubygems'
require 'bundler'
Bundler.require

require File.expand_path('../lib/sprockets_config', __FILE__)

namespace :assets do

  desc "Cleanup output directory"
  task :cleanup do
    config.cleanup
  end

  desc "Precompile assets"
  task :precompile => [:cleanup] do
    config.precompile
  end

  desc "Start Rack based server"
  task :rackup do
    cmd = "bundle exec rackup config.ru"
    system cmd
  end

  private

  def config
    @config ||= SprocketsConfig.new(YAML::load(File.open("config.yml")))
  end
  
end # namespace
