# frozen_string_literal: true
require 'minitest/autorun'
require 'harpoon'

class TestHarpoon < Minitest::Test
  def test_version
    assert_equal '0.0.1', Harpoon::VERSION
  end
end

