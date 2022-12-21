# frozen_string_literal: true

require_relative 'harpoon/version'
require_relative 'harpoon/collection'

module Harpoon

  CACHE_DIR = "#{ENV['HOME']}/.cache/harpoon"

  Dir.glob("#{CACHE_DIR}/*.yml").each do |f|
    if File.exist? f
      task = Collection.new(f)
      task.load_yaml
      task.launch
    end
  end
end

