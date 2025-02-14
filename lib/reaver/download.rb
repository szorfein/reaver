# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'tempfile'
require 'fileutils'

module Reaver
  extend self

  def download(url, name)
    dest = name
    url = URI(url)
    raise Error, 'url was invalid' if !url.respond_to?(:open)

    options = {}
    options['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; WOW64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.6556.192 Safari/537.36'

    downloaded_file = ''
    Whirly.start do
      Whirly.status = "downloading #{dest}"
      downloaded_file = URI.open(url, options)

      # open-uri will return a StringIO instead of a Tempfile if the filesize
      # is less than 10 KB, so we patch this behaviour by converting it into
      # a Tempfile.
      if downloaded_file.is_a?(StringIO)
        tempfile = Tempfile.new('open-uri', binmode: true)
        IO.copy_stream(downloaded_file, tempfile.path)
        downloaded_file = tempfile
        FileUtils.mv downloaded_file.path, dest
      else
        IO.copy_stream(downloaded_file, dest)
      end

      downloaded_file
    end
  end
end

