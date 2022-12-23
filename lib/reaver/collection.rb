# frozen_string_literal: true

require 'yaml'
require 'time'

module Reaver
  class Collection
    attr_reader :tasks

    def initialize(file)
      @file = file
    end

    def load_yaml
      puts "loading #{@file}..."
      @tasks = YAML.load_file(@file,  permitted_classes: [Time, Symbol])
      # puts @tasks.inspect
    rescue => error
      raise error, "loading YAML fail for #{@file}: #{error.message}"
    end

    def launch
      return unless @tasks

      name = @file.split('/').last
      name = name.split('.').first
      workdir = "#{CACHE_DIR}/#{name}"

      FileUtils.mkdir_p(workdir)

      if @tasks['things'].length >= 1
        puts "  > chdir #{workdir}"
        Dir.chdir(workdir)
        @tasks['things'].each { |t| Reaver.download(t['url'], t['name']) }
      end

      update_time
    end

    def save_yaml
      return if @tasks == nil

      File.open(@file, 'w') { |f| YAML.dump(@tasks, f) }
    end

    private

    def update_time
      return unless @tasks['things'].length >= 1

      now = Time.new
      n = @tasks['time'] if @tasks['time'].is_a?(Integer)
      @tasks['next'] = now + n ||= 0
      @tasks['last_download'] = now
    end
  end
end
