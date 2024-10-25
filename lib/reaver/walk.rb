# frozen_string_literal: true

require 'marcel'
require 'fileutils'

module Reaver
  # extract, move file if need
  class Walk
    def initialize(filename, dest, keep_name, strip)
      @filename = filename
      @dest = dest
      @keep_name = keep_name || false
      @strip = strip
      check_extension
      check_name
      x
    end

    def x
      case @extension
      when %r{^image/(jpeg|png)}
        copy_file
      when %r{^application/zip}
        extract_zip
      when %r{^application/(gzip|x-xz)}
        extract_gzip
      when %r{^font/ttf}
        copy_file
      when %r{^application/(x-elf|x-sh)}
        copy_file_with_x
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
      @final_dest = if @keep_name
                      "#{ENV['HOME']}/#{@dest}/#{name}"
                    else
                      "#{ENV['HOME']}/#{@dest}"
                    end
    end

    def copy_file
      puts "Copying file #{@filename} at #{@final_dest}..."
      FileUtils.mkdir_p @final_dest
      FileUtils.cp @filename, "#{@final_dest}/#{@filename}"
    rescue Errno::ETXTBSY => e
      puts "You should stop program before update > #{e}"
    end

    def copy_file_with_x
      copy_file
      File.chmod 0700, "#{@final_dest}/#{@filename}"
    end

    def extract_zip
      puts "Extracting zip archive #{@filename} at #{@final_dest}..."
      FileUtils.mkdir_p @final_dest
      `unzip -o -j #{@filename} -d #{@final_dest}`
    end

    def extract_gzip
      ext = @extension.split('/').last
      puts "Extracting #{ext} archive #{@filename} at #{@final_dest}..."
      FileUtils.mkdir_p @final_dest
      `tar x --strip-components=#{@strip} -f #{@filename} --one-top-level=#{@final_dest}`
    end
  end
end
