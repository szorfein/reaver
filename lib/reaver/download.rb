# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'tempfile'
require 'fileutils'

# Download link
module Reaver
  module_function

  def download(url, name)
    dest = name
    url = URI(url)
    raise Error, 'url was invalid' unless url.respond_to?(:open)

    options = {}

    Whirly.start do
      Whirly.status = "downloading #{dest}"
      options['User-Agent'] = agent_list
      downloaded_file = URI.open(url, options)

      get_the_link(downloaded_file, dest)
    end
  end

  # List from https://www.useragents.me/
  # return a random user-agent with sample
  def agent_list
    ag = ['Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.10 Safari/605.1.1',
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.3',
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.3',
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.3',
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36 Trailer/93.3.8652.5']
    ag.sample
  end

  def get_the_link(file, dest)
    # open-uri will return a StringIO instead of a Tempfile if the filesize
    # is less than 10 KB, so we patch this behaviour by converting it into
    # a Tempfile.
    if file.is_a?(StringIO)
      tempfile = Tempfile.new('open-uri', binmode: true)
      IO.copy_stream(file, tempfile.path)
      FileUtils.mv file.path, dest
    else
      IO.copy_stream(file, dest)
    end
    file
  end
end
