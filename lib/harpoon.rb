# frozen_string_literal: true

require_relative 'harpoon/version'
require_relative 'harpoon/collection'

module Harpoon

  CACHE_DIR = "#{ENV['HOME']}/.cache/harpoon"

  Dir.glob("#{CACHE_DIR}/*.yml").each do |f|
    if File.exist? f
      collection = Collection.new(f)
      collection.load_yaml

      if collection.tasks
        puts "Next download >> #{collection.tasks['next']}"
        if collection.tasks['next'] < Time.new
          puts ' >> Download time for ' + f.split('/').last
          collection.launch
        end
      end

      collection.save_yaml
    end
  end
end
