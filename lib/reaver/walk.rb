# frozen_string_literal: true

require 'marcel'
require 'fileutils'

module Reaver
  # extract, move file if need
  class Walk
    def initialize(filename, dest, keep_name)
      @filename = filename
      @dest = dest
      @keep_name = keep_name || false
      check_extension
      check_name
      x
    end

    def x
      case @extension
      when %r{^image/jpeg} || %r{^image/png}
        copy_file
      when %r{^application/zip}
        extract_zip
      when %r{^application/gzip}
        extract_gzip
      when %r{^font/ttf}
        copy_file
      else
        puts "Filetype #{@extension} not yet supported, skipping..."
      end
    end

    private

    def check_extension
      File.open @filename do |f|
        @extension = Marcel::MimeType.for f
      end
    end

    def check_name
      name = @filename.split('.').first
      @final_dest = @keep_name ? "#{@dest}/#{name}" : @dest
    end

    def copy_file
      puts "Copying file #{@filename} at #{@final_dest}..."
      FileUtils.mkdir_p @final_dest
      FileUtils.cp @filename, "#{@final_dest}/#{@filename}"
    end

    def extract_zip
      puts "Extracting zip archive #{@filename} at #{@final_dest}..."
      FileUtils.mkdir_p @final_dest
      `unzip -j #{@filename} -d #{@final_dest}`
    end

    def extract_gzip
      puts "Extracting gzip archive #{@filename} at #{@final_dest}..."
      FileUtils.mkdir_p @final_dest
      `tar -x --strip-components=1 -f #{@filename} --one-top-level=#{@final_dest}`
    end
  end
end
