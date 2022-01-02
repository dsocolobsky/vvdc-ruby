module Vvdc
  class Compiler
    def initialize
      @code = ""
    end

    def emit(line)
      @code << line << "\n"
    end

    def emit_mov(reg, from)
      emit("mov " << reg << ", " << from)
    end

    def emit_prelude
      emit "section .text"
      emit "global _start"
      emit "_start:"
    end

    def emit_epilogue
      emit "int 0x80"
    end

    def emit_return_expression(expression)
      case expression.right
      when Vvdc::NumericExpression
        emit_mov "rbx", expression.right.to_s
      end
    end

    def compile(expressions)
      emit_prelude
      expressions.each do |expression|
        case expression
        when Vvdc::ReturnExpression
          emit_return_expression expression
        end
      end
      emit_epilogue

      @code
    end
  end
end
