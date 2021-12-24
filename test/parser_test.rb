require "minitest/autorun"

require "vvdc/lexer"

class LexerTest < Minitest::Test
  def test_simple_tokens
    lexer = Vvdc::Lexer.new
    program = "! + - * ; ( ) { } = < >"

    tokens = lexer.scan(program)

    assert_equal program.delete(" ").chars, tokens.map { |token| token.literal }
  end

  def test_simple_tokens_no_spaces
    lexer = Vvdc::Lexer.new
    program = "!+-*;(){}=<>"

    tokens = lexer.scan(program)

    assert_equal program.chars, tokens.map { |token| token.literal }
  end

  def test_combined_tokens
    lexer = Vvdc::Lexer.new
    program = "== != <= >="

    tokens = lexer.scan(program)

    assert_equal program.split(" "), tokens.map { |token| token.literal }
  end

  def test_combined_tokens_no_spaces
    lexer = Vvdc::Lexer.new
    program = "===!=<=>="

    tokens = lexer.scan(program)

    assert_equal ["==", "=", "!=", "<=", ">="], tokens.map { |token| token.literal }
  end

  def test_numbers_identifiers_and_strings
    lexer = Vvdc::Lexer.new
    program = "1337 identifier otheridentifier \"string with spaces\""

    tokens = lexer.scan(program)

    assert_equal ["1337", "identifier", "otheridentifier", "string with spaces"], tokens.map { |token| token.literal }
    assert_equal [:number, :identifier, :identifier, :string], tokens.map { |token| token.type }
  end

  def test_numbers_identifiers_mixed_with_symbols
    lexer = Vvdc::Lexer.new
    program = "42<16==banana5 32"

    tokens = lexer.scan(program)

    assert_equal ["42", "<", "16", "==", "banana5", "32"], tokens.map { |token| token.literal }
    assert_equal [:number, :symbol, :number, :symbol, :identifier, :number], tokens.map { |token| token.type }
  end
end
