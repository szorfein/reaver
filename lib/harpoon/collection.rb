# frozen_string_literal: true

require 'yaml'

module Harpoon
  class Collection
    def initialize(file)
      @file = file
    end

    def load_yaml
      puts "loading #{@file}..."
      @tasks = YAML.load_file(@file,  permitted_classes: [Time, Symbol])
      puts @tasks.inspect
      #@tasks.merge!(state_file) unless state_file == nil
    rescue => error
      raise error, "loading YAML fail for #{@file}: #{error.message}"
    end

    def launch
      return if @tasks == nil

      if @tasks['things'].length >= 1
        puts "many things to do."
        @tasks['things'].each { |t| puts "x #{t['name']}, u #{t['url']}" }
      end

      if @tasks['time'].is_a?(Integer)
        puts "good number #{@tasks['time']}"
      end
    end
  end
end
