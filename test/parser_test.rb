require "minitest/autorun"

require "vvdc/lexer"

class LexerTest < Minitest::Test
  def test_simple_tokens
    lexer = Vvdc::Lexer.new
    program = "! + - * ; ( ) { } = < >"

    tokens = lexer.scan(program)

    assert_equal program.delete(' ').split(''), tokens
  end

  def test_simple_tokens_no_spaces
    lexer = Vvdc::Lexer.new
    program = "!+-*;(){}=<>"

    tokens = lexer.scan(program)

    assert_equal program.split(''), tokens
  end

  def test_combined_tokens
    lexer = Vvdc::Lexer.new
    program = "== != <= >="

    tokens = lexer.scan(program)

    assert_equal program.split(' '), tokens
  end

  def test_combined_tokens_no_spaces
    lexer = Vvdc::Lexer.new
    program = "===!=<=>="

    tokens = lexer.scan(program)

    assert_equal ["==", "=", "!=", "<=", ">="], tokens
  end
end
