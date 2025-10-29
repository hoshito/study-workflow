require 'minitest/autorun'
require_relative '../hello'

class HelloTest < Minitest::Test
  def test_default_greeting
    assert_equal "Hello, World!", Hello.greeting
  end

  def test_greeting_with_name
    assert_equal "Hello, GitHub!", Hello.greeting("GitHub")
  end
end