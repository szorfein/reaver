# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'net/https'
# require 'tempfile'
# require 'fileutils'

# Download link
module Reaver
  module_function

  # https://github.com/ruby/open-uri/blob/master/lib/open-uri.rb
  def download(url, name, limit = 5)
    dest = name
    url = URI.parse(url)
    raise ArgumentError, 'url was invalid' unless url.respond_to?(:open)
    raise ArgumentError, 'too many HTTP redirects' if limit.zero?

    http_object = Net::HTTP.new(url.host, url.port)
    just_add_ssl(http_object) # if url.scheme == 'https'
    http_object.start do |http|
      request = Net::HTTP::Get.new(url.request_uri, { 'user-agent' => agent_list })
      response_stuff(http, request, dest, limit)
    end
  end

  def response_stuff(http, request, dest, limit)
    http.read_timeout = 500
    http.request request do |response|
      case response
      when Net::HTTPSuccess then get_the_file(response, dest)
      when Net::HTTPRedirection then download(response['location'], dest, limit - 1)
      else
        raise response.value
      end
    end
  end

  def just_add_ssl(http_object)
    store = OpenSSL::X509::Store.new
    store.set_default_paths
    http_object.use_ssl = true
    http_object.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http_object.cert_store = store
  end

  def get_the_file(res, dest)
    Whirly.start do
      Whirly.status = "Downloading #{dest}"
      File.binwrite(dest, res.read_body)
      # open(dest, 'wb') do |io|
      # res.read_body do |chunk|
      #   io.write chunk
      # end
      # end
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

  # def get_the_link(file, dest)
  # open-uri will return a StringIO instead of a Tempfile if the filesize
  # is less than 10 KB, so we patch this behaviour by converting it into
  # a Tempfile.
  # if file.is_a?(StringIO)
  #   tempfile = Tempfile.new('open-uri', binmode: true)
  #   IO.copy_stream(file, tempfile.path)
  #   FileUtils.mv tempfile.path, dest
  # else
  #   IO.copy_stream(file, dest)
  # end
  # file
  # end
end
