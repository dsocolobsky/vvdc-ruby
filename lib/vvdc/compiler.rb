module Vvdc
  class Compiler
    def initialize
      @code = ""
    end

    def emit(line)
      @code << line << "\n"
    end

    def emit_prelude
      emit "section .text"
      emit "global _start"
      emit "_start:"
    end

    def emit_epilogue
      emit "int 0x80"
    end

    def compile(expressions)
      emit_prelude
      expressions.each do |expression|
        case expression.class
        when Vvdc::ReturnExpression
          nil
        end
      end
      emit_epilogue

      @code
    end
  end
end
