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

  def test_negation
    lexer = Vvdc::Lexer.new
    program = "!42;"
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    assert_equal [Vvdc::NegationExpression], expressions.map { |exp| exp.class }
    assert_equal [Vvdc::NumericExpression, 42], [expressions[0].right.class, expressions[0].right.value]
  end

  def test_negation_of_a_negation
    lexer = Vvdc::Lexer.new
    program = "!!3;"
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    not_not_3 = expressions[0]
    assert_equal Vvdc::NegationExpression, not_not_3.class

    not_3 = not_not_3.right
    assert_equal Vvdc::NegationExpression, not_3.class

    assert_equal [Vvdc::NumericExpression, 3], [not_3.right.class, not_3.right.value]
  end
end
