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
        #puts "loading metadata #{@file}..."
        if RUBY_VERSION >= '3.0'
          @info = YAML.load_file(@file,  permitted_classes: [Time, Symbol])
        else
          @info = YAML.load_file(@file)
        end
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
      return if !@collection.tasks['things'] || @collection.tasks['things'].nil?

      now = Time.new
      n = @collection.tasks['time'] if @collection.tasks['time'].is_a?(Integer)
      @info['next'] = now + n ||= now
      @info['last_download'] = now
    end
  end
end
