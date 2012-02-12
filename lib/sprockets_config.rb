require 'pathname'
require 'logger'
require 'fileutils'

require File.expand_path('../static_compiler', __FILE__)

class SprocketsConfig

  BUNDLES           = %w(common.css common.js nested/common.js)
  ASSETS            = %w(javascripts stylesheets images fonts)

  attr_reader :source_dir, :build_dir, :bundles, :assets

  def initialize(options = {})
    raise "No src_dir specified"           unless options['src_dir']
    raise "No build_dir specified"         unless options['build_dir']
    raise "No sprockets bundles specified" unless options['bundles']
    raise "No sprockets assets specified"  unless options['assets']

    @source_dir = root.join(options['src_dir'])
    @build_dir  = root.join(options['build_dir'])
    @bundles    = options['bundles']
    @assets     = options['assets']

    logger.info "Initialized Sprockets Config..."
    logger.info "Source Directory: #{@source_dir.realpath}"
    logger.info "Assets Bundles: #{@bundles.inspect}"
    logger.info "Assets Path: #{@assets.inspect}"
  end

  def logger
    @logger ||= begin
      log = Logger.new(STDOUT)
      log.datetime_format = "%Y-%m-%d %H:%M:%S"
      log.formatter = proc { |severity, datetime, progname, msg|
        "[#{datetime.strftime(log.datetime_format)} Sprockets] #{msg}\n"
      }
      log
    end
  end

  def precompile
    FileUtils.mkpath(build_dir)

    manifest = static_compiler.precompile(bundles)
    write_manifest(manifest)
  end

  def cleanup
    logger.info "Cleaning up build dir: #{build_dir.realpath}"
    FileUtils.rm_rf(build_dir)
  end

  def sprockets
    @sprockets ||= create_sprockets_env
  end

  private

  def root
    Pathname(File.join(File.dirname(__FILE__), '/..'))
  end

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
    sprockets = Sprockets::Environment.new(root) do |env|
      env.logger = logger

      env.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
      env.css_compressor = YUI::CssCompressor.new

      paths =   ["#{source_dir}/"].map{|path| assets.map{|folder| "#{path}#{folder}" } }.flatten
      paths.each { |path| env.append_path(path.to_s) }
    end
  end

end
