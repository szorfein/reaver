# frozen_string_literal: true

require_relative 'harpoon/version'
require_relative 'harpoon/banner'
require_relative 'harpoon/download'

require 'whirly'
require 'fileutils'

module Harpoon
  CACHE_DIR = "#{ENV['HOME']}/.cache/harpoon"

  Whirly.configure spinner: 'bouncingBar',
    color: true,
    ambiguous_characters_width: 1

  FileUtils.mkdir_p(CACHE_DIR)
end
