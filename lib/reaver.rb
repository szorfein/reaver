# frozen_string_literal: true

require_relative 'reaver/version'
require_relative 'reaver/banner'
require_relative 'reaver/download'
require_relative 'reaver/collection'
require_relative 'reaver/metadata'

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

    puts ">> Search collections in #{WORKDIR}"

    Dir.glob("#{WORKDIR}/*.yml").each do |f|
      name = f.split('/').last
      name = name.split('.').first
      workdir = "#{CACHE_DIR}/#{name}"

      FileUtils.mkdir_p(workdir)

      collection = Collection.new(f)
      collection.load_yaml

      if collection.tasks
        metadata = MetaData.new(workdir, collection)
        metadata.load_yaml
        next_download = metadata.info['next']

        if next_download < Time.new
          puts ' >> Download time for ' + name
          Dir.chdir(workdir)
          puts "  > chdir #{workdir}"
          collection.launch(metadata)
        else
          puts "Next download for #{name} >> #{next_download}"
        end

        metadata.save_yaml
      end
    end
  end
end
