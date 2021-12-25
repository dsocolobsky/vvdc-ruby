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

  def expect_number(expected, actual)
    assert_instance_of Vvdc::NumericExpression, actual
    assert_equal expected, actual.value
  end

  def expect_negation(exp)
    assert_kind_of Vvdc::NegationExpression, exp
  end

  def expect_addition(exp)
    assert_kind_of Vvdc::AdditionExpression, exp
  end

  def expect_substraction(exp)
    assert_kind_of Vvdc::SubstractionExpression, exp
  end

  def test_literals
    expressions = parse('1337 "banana" tomato')

    assert_equal %w[1337 banana tomato], expressions.map(&:to_s)
    assert_equal [Vvdc::NumericExpression, Vvdc::StringExpression, Vvdc::IdentifierExpression],
      expressions.map(&:class)
  end

  def test_negation
    exp = parse("!42;")[0]

    expect_negation exp
    expect_number 42, exp.right
  end

  def test_negation_of_a_negation
    not_not_3 = parse("!!3;")[0]

    expect_negation not_not_3

    not_3 = not_not_3.right
    expect_negation not_3

    expect_number 3, not_3.right
  end

  def test_addition
    five_plus_eleven = parse("5 + 11;")[0]

    expect_addition five_plus_eleven

    expect_number 5, five_plus_eleven.left
    expect_number 11, five_plus_eleven.right
  end

  def test_addition_of_multiple_numbers
    add_5_11_24_3 = parse("5 + 11 + 24 + 3;")[0]

    expect_addition add_5_11_24_3
    expect_number 5, add_5_11_24_3.left

    add_11_24_3 = add_5_11_24_3.right
    expect_addition add_11_24_3
    expect_number 11, add_11_24_3.left

    add_24_3 = add_11_24_3.right
    expect_addition add_24_3
    expect_number 24, add_24_3.left
    expect_number 3, add_24_3.right
  end

  def test_substraction
    sub = parse("24 - 4;")[0]

    assert_kind_of Vvdc::SubstractionExpression, sub
    expect_number 24, sub.left
    expect_number 4, sub.right
  end

  def test_return_a_number
    ret = parse("return 42;")[0]

    assert_kind_of Vvdc::ReturnExpression, ret
    expect_number 42, ret.right
  end

  def return_an_addition
    ret = parse("return 3 + 15;")

    assert_kind_of Vvdc::ReturnExpression, ret

    addition = ret.right
    expect_addition addition
    expect_number 3, addition.left
    expect_number 15, addition.right
  end

  def test_return_a_substraction
    ret = parse("return 23 - 3 - 10;")[0]

    assert_kind_of Vvdc::ReturnExpression, ret

    sub_23_3_10 = ret.right
    expect_substraction sub_23_3_10
    expect_number 23, sub_23_3_10.left

    sub_3_10 = sub_23_3_10.right
    expect_number 3, sub_3_10.left
    expect_number 10, sub_3_10.right
  end
end
