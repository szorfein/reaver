# frozen_string_literal: true

require_relative 'reaver/version'
require_relative 'reaver/banner'
require_relative 'reaver/download'
require_relative 'reaver/metadata'
require_relative 'reaver/collection'
require_relative 'reaver/walk'
require_relative 'reaver/git'

require 'whirly'
require 'fileutils'

# Main class
module Reaver
  module_function

  # Where downloads things
  CACHE_DIR = "#{ENV['HOME']}/.cache/reaver"

  # Search collection paths
  WORKDIR = ENV['XDG_CONFIG_HOME'] ? "#{ENV['XDG_CONFIG_HOME']}/reaver" : "#{ENV['HOME']}/.config/reaver"

  # Configure Whirly
  Whirly.configure spinner: 'bouncingBar',
                   color: true,
                   ambiguous_characters_width: 1

  FileUtils.mkdir_p(WORKDIR)

  def main
    Dir.glob("#{WORKDIR}/*.yml").each do |f|
      workdir = collection_name(f)
      collection = load_collection(f)

      next unless collection.tasks

      metadata = load_metadata(workdir, collection)
      if analyze_collection(metadata.info['next'], collection.tasks['force_download'])
        time_to_download(workdir, collection, metadata)
      end

      metadata.save_yaml
    end
  end

  def load_collection(pathname)
    collection = Collection.new(pathname)
    collection.load_yaml
    collection
  end

  def load_metadata(workdir, collection)
    FileUtils.mkdir_p(workdir)
    md = MetaData.new(workdir, collection)
    md.load_yaml
    md
  end

  def collection_name(filename)
    name = filename.split('/').last
    name = name.split('.').first
    "#{CACHE_DIR}/#{name}"
  end

  def analyze_collection(info_next, forced = nil)
    next_download = info_next
    force_download = forced || false
    return true if next_download < Time.new || force_download

    puts " > Next download > #{next_download}"
    false
  end

  def time_to_download(workdir, collection, metadata)
    FileUtils.chdir(workdir)
    collection.launch(metadata)
    # collection.save_yaml if force_download
  end
end
