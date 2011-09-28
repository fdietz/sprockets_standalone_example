require 'rubygems'
require 'bundler'

Bundler.require

require File.join(File.dirname(__FILE__), '/lib/sprockets_config')

config = SprocketsConfig.new(YAML::load(File.open("config.yml")))

map "/assets" do
  run config.sprockets
end

map "/" do
  run lambda { |env|
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('public/index.html', File::RDONLY)
    ]
  }
end
