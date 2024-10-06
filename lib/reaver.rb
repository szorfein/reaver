# frozen_string_literal: true

require_relative 'reaver/version'
require_relative 'reaver/banner'
require_relative 'reaver/download'
require_relative 'reaver/metadata'
require_relative 'reaver/collection'
require_relative 'reaver/walk'

require 'whirly'
require 'fileutils'

module Reaver
  # Where downloads things
  CACHE_DIR = "#{ENV['HOME']}/.cache/reaver"

  # Search collection paths
  if ENV['XDG_CONFIG_HOME']
    WORKDIR = "#{ENV['XDG_CONFIG_HOME']}/reaver"
  else
    WORKDIR = "#{ENV['HOME']}/.config/reaver"
  end

  # Configure Whirly
  Whirly.configure spinner: 'bouncingBar',
                   color: true,
                   ambiguous_characters_width: 1

  def self.main
    FileUtils.mkdir_p(WORKDIR)

    #puts ">> Search collections in #{WORKDIR}"

    Dir.glob("#{WORKDIR}/*.yml").each do |f|
      name = f.split('/').last
      name = name.split('.').first
      workdir = "#{CACHE_DIR}/#{name}"

      FileUtils.mkdir_p(workdir)

      collection = Collection.new(f)
      collection.load_yaml

      #puts collection.tasks

      next unless collection.tasks

      metadata = MetaData.new(workdir, collection)
      metadata.load_yaml
      next_download = metadata.info['next']
      force_download = collection.tasks['force_download'] || false
      #puts "should we force #{force_download}"

      if next_download < Time.new || force_download
          #puts ' >> Download time for ' + name
        FileUtils.chdir(workdir)
        #puts "  > chdir #{workdir}"
        collection.launch(metadata)
        collection.save_yaml if force_download
      else
        puts " > Next download > #{next_download}"
      end

      metadata.save_yaml
    end
  end
end
