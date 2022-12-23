# frozen_string_literal: true

module Reaver
  class MetaData
    attr_accessor :info

    def initialize(dirname, collection)
      @dirname = dirname
      @collection = collection
      @file = "#{@dirname}/metadata.yml"
      @info = { 'changed' => false, 'next' => Time.new }
    end

    def load_yaml
      if File.exist? @file
        puts "loading metadata #{@file}..."
        @info = YAML.load_file(@file,  permitted_classes: [Time, Symbol])
        # puts @info.inspect
      else
        File.open(@file, 'w') { |f| YAML.dump(@info, f) }
      end
    end

    def save_yaml
      update_time

      File.open(@file, 'w') { |f| YAML.dump(@info, f) }
    end

    private

    def update_time
      return unless @collection.tasks['things'].length >= 1

      now = Time.new
      n = @collection.tasks['time'] if @collection.tasks['time'].is_a?(Integer)
      @info['next'] = now + n ||= now
      @info['last_download'] = now
    end
  end
end
