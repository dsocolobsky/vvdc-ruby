# frozen_string_literal: true

require "minitest/autorun"

require "vvdc/lexer"

class LexerTest < Minitest::Test
  def test_simple_tokens
    lexer = Vvdc::Lexer.new
    program = "! + - * ; ( ) { } = < >"

    tokens = lexer.scan(program)

    assert_equal program.delete(" ").chars, tokens.map(&:literal)
  end

  def test_simple_tokens_no_spaces
    lexer = Vvdc::Lexer.new
    program = "!+-*;(){}=<>"

    tokens = lexer.scan(program)

    assert_equal program.chars, tokens.map(&:literal)
  end

  def test_combined_tokens
    lexer = Vvdc::Lexer.new
    program = "== != <= >="

    tokens = lexer.scan(program)

    assert_equal program.split(" "), tokens.map(&:literal)
  end

  def test_combined_tokens_no_spaces
    lexer = Vvdc::Lexer.new
    program = "===!=<=>="

    tokens = lexer.scan(program)

    assert_equal ["==", "=", "!=", "<=", ">="], tokens.map(&:literal)
  end

  def test_numbers_identifiers_and_strings
    lexer = Vvdc::Lexer.new
    program = '1337 identifier otheridentifier "string with spaces"'

    tokens = lexer.scan(program)

    assert_equal ["1337", "identifier", "otheridentifier", "string with spaces"], tokens.map(&:literal)
    assert_equal %i[number identifier identifier string], tokens.map(&:type)
  end

  def test_numbers_identifiers_mixed_with_symbols
    lexer = Vvdc::Lexer.new
    program = "42<16==banana5 32"

    tokens = lexer.scan(program)

    assert_equal %w[42 < 16 == banana5 32], tokens.map(&:literal)
    assert_equal %i[number symbol number symbol identifier number], tokens.map(&:type)
  end

  def test_keywords
    lexer = Vvdc::Lexer.new
    program = "if print while return let fn notakeyword"

    tokens = lexer.scan(program)

    assert_equal program.split(" "), tokens.map(&:literal)
    assert_equal %i[keyword_if keyword_print keyword_while keyword_return
      keyword_let keyword_fn identifier], tokens.map(&:type)
  end
end
