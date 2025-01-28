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

    def save_yaml
      in_yaml = YAML.dump(@tasks)
      File.write(@file, in_yaml)
    end

    def launch(metadata)
      return unless @tasks || @tasks['things'].length.zero?

      @tasks['things'].each do |task|
        if task['git']
          Reaver::Git.new(task['url'], task['dest_dir'])
        else
          do_thing(task)
        end
        metadata.info['changed'] = @changed
      end
    end

    protected

    def do_thing(task)
      hash_exist(task['name'])
      Reaver.download(task['url'], task['name'])
      compare_to_old_hash(task['name']) if @old_hash
      need_to_do_something_with(task) if @changed || !@old_hash
      @tasks['force_download'] = false
      @changed = false
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
      keep_name = @tasks['keep_name'] || file['keep_name'] || false
      strip_components = file['strip_components'] || '1'
      return unless dest

      Reaver::Walk.new(file['name'],
                       dest,
                       keep_name,
                       strip_components)
    end
  end
end
