# frozen_string_literal: true

require 'fileutils'

module Reaver
  # Treat git
  class Git
    def initialize(url, dest)
      @dest = "#{ENV['HOME']}/#{dest}"
      @url = url
      x
    end

    protected

    def x
      if !Dir.exist?(@dest)
        git_clone
      elsif Dir.exist?(@dest) && !Dir.exist?("#{@dest}/.git")
        FileUtils.rm_rf @dest
        git_clone
      elsif Dir.exist?(@dest) && Dir.exist?("#{@dest}/.git")
        git_sync
      end
    end

    private

    def git_clone
      puts "Git cloning #{@url} to #{@dest}..."
      `git clone #{@url} #{@dest}`
    end

    def git_sync
      puts "Git fetching update(s) on #{@dest}..."
      `cd #{@dest} && git pull`
    end
  end
end
