# frozen_string_literal: true

require 'yaml'
require 'time'
require 'digest'

module Reaver
  # Loading collection from ~/.config/reaver/<filename.yml> and threat them
  class Collection
    attr_reader :tasks

    def initialize(file)
      @file = file
      @changed = false
    end

    def load_yaml
      puts ">> Loading #{@file}..."
      @tasks = if RUBY_VERSION >= '3.0'
                 YAML.load_file(@file, permitted_classes: [Time, Symbol])
               else
                 @tasks = YAML.load_file(@file)
               end
    rescue => e
      raise e, "loading YAML fail for #{@file}: #{e.message}"
    end

    def launch(metadata)
      return unless @tasks || @tasks['things'].length.zero?

      @tasks['things'].each do |t|
        hash_exist(t['name'])
        Reaver.download(t['url'], t['name'])
        compare_to_old_hash(t['name']) if @old_hash
        need_to_do_something_with(t) if @changed || !@old_hash
        metadata.info['changed'] = @changed
      end
    end

    private

    def hash_exist(file)
      if File.exist? file
        @old_hash = Digest::MD5.file file
      else
        @changed = true
      end
    end

    def compare_to_old_hash(filename)
      hash = Digest::MD5.file filename
      @changed = true if @old_hash.hexdigest != hash.hexdigest
    end

    def need_to_do_something_with(file)
      dest = @tasks['all_to_dest_dir'] || file['dest_dir']
      keep_name = @tasks['keep_name'] || false
      Reaver::Walk.new(file['name'], dest, keep_name) if dest
    end
  end
end
