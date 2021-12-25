# frozen_string_literal: true

require "minitest/autorun"

require "vvdc/lexer"

class LexerTest < Minitest::Test
  def scan(program)
    lexer = Vvdc::Lexer.new
    lexer.scan(program)
  end

  def test_simple_tokens
    program = "! + - * ; ( ) { } = < >"
    tokens = scan(program)

    assert_equal program.delete(" ").chars, tokens.map(&:literal)
  end

  def test_simple_tokens_no_spaces
    program = "!+-*;(){}=<>"
    tokens = scan(program)

    assert_equal program.chars, tokens.map(&:literal)
  end

  def test_combined_tokens
    program = "== != <= >="
    tokens = scan(program)

    assert_equal program.split(" "), tokens.map(&:literal)
  end

  def test_combined_tokens_no_spaces
    tokens = scan("===!=<=>=")

    assert_equal ["==", "=", "!=", "<=", ">="], tokens.map(&:literal)
  end

  def test_numbers_identifiers_and_strings
    tokens = scan('1337 identifier otheridentifier "string with spaces"')

    assert_equal ["1337", "identifier", "otheridentifier", "string with spaces"], tokens.map(&:literal)
    assert_equal %i[number identifier identifier string], tokens.map(&:type)
  end

  def test_numbers_identifiers_mixed_with_symbols
    tokens = scan("42<16==banana5 32")

    assert_equal %w[42 < 16 == banana5 32], tokens.map(&:literal)
    assert_equal %i[number symbol number symbol identifier number], tokens.map(&:type)
  end

  def test_keywords
    program = "if print while return let fn notakeyword"
    tokens = scan(program)

    assert_equal program.split(" "), tokens.map(&:literal)
    assert_equal %i[keyword_if keyword_print keyword_while keyword_return
      keyword_let keyword_fn identifier], tokens.map(&:type)
  end

  def test_newlines
    tokens = scan("if 42\nvariable\n\n\"mystring\"")

    assert_equal %w[if 42 variable mystring], tokens.map(&:literal)
    assert_equal %i[keyword_if number identifier string], tokens.map(&:type)
  end
end
