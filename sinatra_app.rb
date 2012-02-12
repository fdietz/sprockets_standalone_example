require File.expand_path("../lib/sprockets_config", __FILE__)

module AssetHelpers
  def asset_path(source)
    "/assets/#{sprockets.find_asset(source).digest_path}?body=1"
  end

  def javascript_include_tag(source, options = {})
    debug = options.key?(:debug) ? options.delete(:debug) : false

    if debug
      sprockets.find_asset(source).to_a.map { |a| a.pathname }.map do |p| 
        "<script src=#{asset_path(p)}></script>"
      end.join("\n")
    else
      "<script src=#{asset_path(source)}></script>"
    end
  end

  def stylesheet_link_tag(source, options = {})
    debug = options.key?(:debug) ? options.delete(:debug) : false

    if debug
      sprockets.find_asset(source).to_a.map { |a| a.pathname }.map do |p| 
        %{<link rel="stylesheet" href="#{asset_path(p)}">}
      end.join("\n")
    else
      %{<link rel="stylesheet" href="#{asset_path(source)}">}
    end
  end

end

class SinatraApp < Sinatra::Base
  set :root, File.expand_path('../', __FILE__)
  set :sprockets_config, SprocketsConfig.new(YAML::load(File.open("config.yml")))

  def sprockets
    settings.sprockets_config.sprockets
  end

  configure do
  end
  
  helpers do
    include AssetHelpers
  end
  
  get "/" do
    erb :index
  end

end