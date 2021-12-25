# frozen_string_literal: true

require "minitest/autorun"

require "vvdc/lexer"
require "vvdc/parser"

class ParserTest < Minitest::Test
  def test_literals
    lexer = Vvdc::Lexer.new
    program = '1337 "banana" tomato'
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    assert_equal %w[1337 banana tomato], expressions.map(&:to_s)
    assert_equal [Vvdc::NumericExpression, Vvdc::StringExpression, Vvdc::IdentifierExpression],
      expressions.map(&:class)
  end

  def test_negation
    lexer = Vvdc::Lexer.new
    program = "!42;"
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    assert_equal [Vvdc::NegationExpression], expressions.map(&:class)
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

  def test_addition
    lexer = Vvdc::Lexer.new
    program = "5 + 11;"
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    five_plus_eleven = expressions[0]
    assert_equal Vvdc::AdditionExpression, five_plus_eleven.class

    five = five_plus_eleven.left
    eleven = five_plus_eleven.right

    assert_equal [Vvdc::NumericExpression, 5], [five.class, five.value]
    assert_equal [Vvdc::NumericExpression, 11], [eleven.class, eleven.value]
  end

  def test_addition_of_multiple_numbers
    lexer = Vvdc::Lexer.new
    program = "5 + 11 + 24 + 3;"
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)

    add_5_11_24_3 = expressions[0]
    assert_equal Vvdc::AdditionExpression, add_5_11_24_3.class

    add_5 = add_5_11_24_3.left
    add_11_24_3 = add_5_11_24_3.right
    assert_equal [Vvdc::NumericExpression, 5], [add_5.class, add_5.value]
    assert_equal Vvdc::AdditionExpression, add_11_24_3.class

    add_11 = add_11_24_3.left
    add_24_3 = add_11_24_3.right
    assert_equal [Vvdc::NumericExpression, 11], [add_11.class, add_11.value]
    assert_equal Vvdc::AdditionExpression, add_24_3.class

    add_24 = add_24_3.left
    add_3 = add_24_3.right
    assert_equal [Vvdc::NumericExpression, 24], [add_24.class, add_24.value]
    assert_equal [Vvdc::NumericExpression, 3], [add_3.class, add_3.value]
  end
end
