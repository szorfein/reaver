# frozen_string_literal: true

require 'yaml'
require 'time'
require 'digest'

module Reaver
  class Collection
    attr_reader :tasks

    def initialize(file)
      @file = file
      @changed = false
    end

    def load_yaml
      puts ">> Loading #{@file}..."
      if RUBY_VERSION >= '3.0'
        @tasks = YAML.load_file(@file,  permitted_classes: [Time, Symbol])
      else
        @tasks = YAML.load_file(@file)
      end
    rescue => error
      raise error, "loading YAML fail for #{@file}: #{error.message}"
    end

    def launch(metadata)
      return unless @tasks

      if @tasks['things'].length >= 1
        @tasks['things'].each do |t|
          if File.exist? t['name']
            old_hash = Digest::MD5.file t['name']
          else
            @changed = true
          end

          Reaver.download(t['url'], t['name']) 
          compare_hash(t['name'], old_hash) if old_hash

          metadata.info['changed'] = @changed
        end
      end
    end

    private

    def compare_hash(filename, old_hash)
      hash = Digest::MD5.file filename
      @changed = true if old_hash.hexdigest != hash.hexdigest
    end
  end
end
