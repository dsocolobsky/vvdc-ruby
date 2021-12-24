require "minitest/autorun"

require "vvdc/parser"

class ParserTest < Minitest::Test
  def test_two
    parser = Vvdc::Parser.new
    assert_equal 2, parser.two
  end
end
