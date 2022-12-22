# frozen_string_literal: true

require_relative 'harpoon/version'
require_relative 'harpoon/banner'
require_relative 'harpoon/download'
require_relative 'harpoon/collection'

require 'whirly'
require 'fileutils'

module Harpoon
  # Where downloads things
  CACHE_DIR = "#{ENV['HOME']}/.cache/harpoon"

  # Search collection paths
  if ENV['XDG_CONFIG_HOME']
    WORKDIR = "#{ENV['XDG_CONFIG_HOME']}/harpoon"
  else
    WORKDIR = "#{ENV['HOME']}/.config/harpoon"
  end

  # Configure Whirly
  Whirly.configure spinner: 'bouncingBar',
    color: true,
    ambiguous_characters_width: 1

  def self.main
    FileUtils.mkdir_p(CACHE_DIR)
    FileUtils.mkdir_p(WORKDIR)

    puts ">> Search collections in #{WORKDIR}"

    Dir.glob("#{WORKDIR}/*.yml").each do |f|
      if File.exist? f
        collection = Collection.new(f)
        collection.load_yaml

        if collection.tasks
          next_download = collection.tasks['next'] ||= Time.new
          name = f.split('/').last

          if next_download < Time.new
            puts ' >> Download time for ' + name
            collection.launch
          else
            puts "Next download for #{name} >> #{next_download}"
          end
        end

        collection.save_yaml
      end
    end
  end
end
