# frozen_string_literal: true

require "minitest/autorun"

require "vvdc/lexer"
require "vvdc/parser"
require "vvdc/compiler"

class LexerTest < Minitest::Test
  def compile(program)
    lexer = Vvdc::Lexer.new
    tokens = lexer.scan(program)
    parser = Vvdc::Parser.new
    expressions = parser.parse(tokens)
    compiler = Vvdc::Compiler.new
    compiler.compile(expressions)
  end

  def test_empty_program
    code = compile("")

    assert_equal %(
section .text
global _start
_start:
int 0x80
).strip, code.strip
  end
end
