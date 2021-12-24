require "minitest/autorun"

require "vvdc/lexer"
require "vvdc/parser"

class ParserTest < Minitest::Test
  def test_literals
    lexer = Vvdc::Lexer.new
    program = "1337 \"banana\" tomato"
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    assert_equal [1337, "banana", "tomato"], expressions.map { |exp| exp.to_s }
    assert_equal [Vvdc::NumericExpression, Vvdc::StringExpression, Vvdc::IdentifierExpression], expressions.map { |exp| exp.class }
  end
end
