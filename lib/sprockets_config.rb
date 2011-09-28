require 'pathname'
require 'logger'
require 'fileutils'

require File.join(File.dirname(__FILE__), 'static_compiler')

ROOT = Pathname(File.join(File.dirname(__FILE__), '/..'))

class SprocketsConfig

  BUNDLES           = %w(common.css common.js nested/common.js)
  ASSETS            = %w(javascripts stylesheets images fonts)

  attr_reader :source_dir, :build_dir, :bundles, :assets

  def initialize(options = {})
    @source_dir = ROOT.join(options['source_dir'] || 'src')
    @build_dir = ROOT.join(options['build_dir'] || 'build')
    @bundles = options['bundles'] || BUNDLES
    @assets = options['assets'] || ASSETS

    logger.info "Initialized Sprockets Config..."
    logger.info "Root Directory: #{ROOT}"
    logger.info "Source Directory: #{source_dir}"
    logger.info "Build Directory: #{build_dir}"
    logger.info "Bundles: #{bundles.inspect}"
    logger.info "Assets: #{assets.inspect}"
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def precompile
    FileUtils.mkpath(build_dir)

    manifest = static_compiler.precompile(bundles)
    write_manifest(manifest)
  end

  def cleanup
    logger.info "Cleaning up build dir: #{build_dir}"
    FileUtils.rm_rf(build_dir)
  end

  def sprockets
    @sprockets ||= create_sprockets_env
  end

  private

  def write_manifest(manifest)
    File.open(manifest_file_path, 'wb') do |f|
      YAML.dump(manifest, f)
    end
  end

  def manifest_file_path
    "#{@build_dir}/manifest.yml"
  end

  def static_compiler
    @static_compiler ||= Sprockets::StaticCompiler.new(sprockets, build_dir, :digest => Digest::MD5)
  end

  def create_sprockets_env
    sprockets = Sprockets::Environment.new(ROOT) do |env|
      env.logger = logger

      env.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
      env.css_compressor = YUI::CssCompressor.new

      paths =   ["#{source_dir}/"].map{|path| assets.map{|folder| "#{path}#{folder}" } }.flatten
      paths.each { |path| env.append_path(path.to_s) }
    end
  end

end
