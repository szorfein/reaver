# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'whirly'
require 'tempfile'
require 'fileutils'

module Reaver
  def self.download(url, name)
    dest = "#{CACHE_DIR}/#{name}"
    url = URI(url)
    raise Error, "url was invalid" if !url.respond_to?(:open)

    options = {}
    options['User-Agent'] = 'MyApp/1.2.3'

    downloaded_file = ''
    Whirly.start do
      Whirly.status = "downloading #{dest}"
      downloaded_file = URI.open(url, options)
    end

    # open-uri will return a StringIO instead of a Tempfile if the filesize
    # is less than 10 KB, so we patch this behaviour by converting it into
    # a Tempfile.
    if downloaded_file.is_a?(StringIO)
      tempfile = Tempfile.new("open-uri", binmode: true)
      IO.copy_stream(downloaded_file, tempfile.path)
      downloaded_file = tempfile
      FileUtils.mv downloaded_file.path, dest
    else
      IO.copy_stream(downloaded_file, dest)
    end

    downloaded_file
  end
end

