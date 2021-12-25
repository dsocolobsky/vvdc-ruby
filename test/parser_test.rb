# frozen_string_literal: true

require "minitest/autorun"

require "vvdc/lexer"
require "vvdc/parser"

class ParserTest < Minitest::Test
  def parse(program)
    lexer = Vvdc::Lexer.new
    tokens = lexer.scan(program)

    parser = Vvdc::Parser.new
    parser.parse(tokens)
  end

  def test_literals
    expressions = parse('1337 "banana" tomato')

    assert_equal %w[1337 banana tomato], expressions.map(&:to_s)
    assert_equal [Vvdc::NumericExpression, Vvdc::StringExpression, Vvdc::IdentifierExpression],
      expressions.map(&:class)
  end

  def test_negation
    expressions = parse("!42;")

    assert_equal [Vvdc::NegationExpression], expressions.map(&:class)
    assert_equal [Vvdc::NumericExpression, 42], [expressions[0].right.class, expressions[0].right.value]
  end

  def test_negation_of_a_negation
    expressions = parse("!!3;")

    not_not_3 = expressions[0]
    assert_equal Vvdc::NegationExpression, not_not_3.class

    not_3 = not_not_3.right
    assert_equal Vvdc::NegationExpression, not_3.class

    assert_equal [Vvdc::NumericExpression, 3], [not_3.right.class, not_3.right.value]
  end

  def test_addition
    expressions = parse("5 + 11;")

    five_plus_eleven = expressions[0]
    assert_equal Vvdc::AdditionExpression, five_plus_eleven.class

    five = five_plus_eleven.left
    eleven = five_plus_eleven.right

    assert_equal [Vvdc::NumericExpression, 5], [five.class, five.value]
    assert_equal [Vvdc::NumericExpression, 11], [eleven.class, eleven.value]
  end

  def test_addition_of_multiple_numbers
    expressions = parse("5 + 11 + 24 + 3;")

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

  def test_return_a_number
    ret = parse("return 42;")[0]

    assert_equal Vvdc::ReturnExpression, ret.class
    assert_equal [Vvdc::NumericExpression, 42], [ret.right.class, ret.right.value]
  end

  def return_an_addition
    ret = parse("return 3 + 15;")

    assert_equal Vvdc::ReturnExpression, ret.class

    addition = ret.right
    assert_equal [Vvdc::AdditionExpression, 3, 15], [addition.class, addition.left.value, addition.right.value]
  end
end
