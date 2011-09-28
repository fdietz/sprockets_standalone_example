require 'rubygems'
require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'
require File.join(File.dirname(__FILE__), '/lib/static_compiler')

Bundler.require

ROOT              = Pathname(File.dirname(__FILE__))
BUILD_DIR         = ROOT.join("build")
SOURCE_DIR        = ROOT.join("src")
MANIFEST_DIR      = BUILD_DIR.join("manifest.yml")
IMAGE_SOURCE_DIR  = ROOT.join('images')

COMPASS_DIR       = ROOT.join('compass')
COMPASS_CONFIG    = COMPASS_DIR.join('config')

BUNDLES           = %w(common.css common.js nested/common.js)
ASSETS            = %w(javascripts stylesheets images fonts)

logger            = Logger.new(STDOUT)

namespace :assets do

  task :cleanup do
    puts "Cleaning up build dir: #{BUILD_DIR}"
    FileUtils.rm_rf(BUILD_DIR)
  end

  task :init do
    $sprockets = Sprockets::Environment.new(ROOT) do |env|
      env.logger = logger

      env.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
      env.css_compressor = YUI::CssCompressor.new

      paths =   ["#{SOURCE_DIR}/"].map{|path| ASSETS.map{|folder| "#{path}#{folder}" } }.flatten
      paths.each { |path| env.append_path(path.to_s) }
    end

    puts "Initialized Sprockets Environment with paths:\n"
    $sprockets.paths.each { |path| puts " * #{path}" }
  end

  task :compile => [:cleanup, :init] do
    FileUtils.mkpath(BUILD_DIR)

    static_compiler = Sprockets::StaticCompiler.new($sprockets, BUILD_DIR, :digest => Digest::MD5)
    manifest = static_compiler.precompile(BUNDLES)

    File.open(MANIFEST_DIR, 'wb') do |f|
      YAML.dump(manifest, f)
    end
  end

  task :manifest => :init do
    raise "No manifest file found: #{MANIFEST_DIR}" unless File.exist?(MANIFEST_DIR)

    puts "Manifest file found at: #{MANIFEST_DIR}"
    manifest = YAML.load_file(MANIFEST_DIR)

    puts "common.js  -> #{$sprockets['common.js'].digest_path}"
    puts "common.css -> #{$sprockets['common.css'].digest_path}"
  end

  task :spriting do
    src = "#{IMAGE_SOURCE_DIR}/*.png"
    cmd = "compass sprite #{src} --config #{COMPASS_CONFIG}"

  end
end # namespace
