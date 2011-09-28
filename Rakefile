require 'rubygems'
require 'bundler'

Bundler.require

require File.join(File.dirname(__FILE__), '/lib/sprockets_config')

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
    cmd = "rackup config.ru"
    system cmd
  end

  def config
    @config ||= SprocketsConfig.new(YAML::load(File.open("config.yml")))
  end
end # namespace
