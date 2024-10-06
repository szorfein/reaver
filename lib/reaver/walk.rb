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
      @extension = Marcel::MimeType.for Pathname.new(@filename)
      x
    end

    def x
      case @extension
      when %r{^image/jpeg} || %r{^image/png} || %r{^font/ttf}
        copy_file
      when %r{^application/zip}
        extract_zip
      when %r{^application/gzip}
        extract_gzip
      else
        puts 'Filetype not yet supported, skipping...'
      end
    end

    private

    def copy_file
      dest = @keep_name ? "#{@dest}/#{@filename}" : "#{@dest}/"
      puts "Copying file #{@filename} at #{dest}..."
      FileUtils.mkdir_p dest
      FileUtils.cp @filename, dest
    end

    def extract_zip
      dest = @keep_name ? "#{@dest}/#{@filename}" : "#{@dest}/"
      puts "Extracting zip archive #{@filename} at #{dest}..."
      FileUtils.mkdir_p dest
      `unzip -j #{@filename} #{dest}`
    end

    def extract_gzip
      dest = @keep_name ? "#{@dest}/#{@filename}" : "#{@dest}/"
      puts "Extracting gzip archive #{@filename} at #{dest}..."
      FileUtils.mkdir_p dest
      `tar xf --strip-components=1 #{@filename} #{dest}`
    end
  end
end
