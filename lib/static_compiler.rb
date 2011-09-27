require 'fileutils'

module Sprockets
  class StaticCompiler
    attr_accessor :env, :target, :digest

    def initialize(env, target, options = {})
      @env = env
      @target = target
      @digest = options.key?(:digest) ? options.delete(:digest) : true
    end

    def precompile(paths)
      #digest = @digest || Digest::MD5
      manifest = {}

      env.each_logical_path do |logical_path|
        next unless precompile_path?(logical_path, paths)
        if asset = env.find_asset(logical_path)
          manifest[logical_path] = compile(asset)
        end
      end
      manifest
    end

    def compile(asset)
      asset_path = digest_asset(asset)
      filename = File.join(target, asset_path)
      FileUtils.mkdir_p File.dirname(filename)
      asset.write_to(filename)
      asset_path
    end

    def precompile_path?(logical_path, paths)
      paths.each do |path|
        if path.is_a?(Regexp)
          return true if path.match(logical_path)
        elsif path.is_a?(Proc)
          return true if path.call(logical_path)
        else
          return true if File.fnmatch(path.to_s, logical_path)
        end
      end
      false
    end

    def digest_asset(asset)
      digest ? asset.digest_path : asset.logical_path
    end
  end
end