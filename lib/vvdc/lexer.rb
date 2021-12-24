module Vvdc

  class Lexer
    def initialize
      @tokens = []
    end

    def scan(program)
      idx = 0
      chars = program.split('')
      while idx < chars.length
        case chars[idx]
        when "+"
          @tokens << "+"
        when "-"
          @tokens << "-"
        when "*"
          @tokens << "*"
        when ";"
          @tokens << ";"
        when "("
          @tokens << "("
        when ")"
          @tokens << ")"
        when "{"
          @tokens << "{"
        when "}"
          @tokens << "}"
        when ")"
          @tokens << ")"
        when "="
          if idx + 1 < program.length and chars[idx+1] == "="
            @tokens << "=="
            idx = idx + 1
          else
            @tokens << "="
          end
        when "!"
          if idx + 1 < program.length and chars[idx+1] == "="
            @tokens << "!="
            idx = idx + 1
          else
            @tokens << "!"
          end
        when "<"
          if idx + 1 < program.length and chars[idx+1] == "="
            @tokens << "<="
            idx = idx + 1
          else
            @tokens << "<"
          end
        when ">"
          if idx + 1 < program.length and chars[idx+1] == "="
            @tokens << ">="
            idx = idx + 1
          else
            @tokens << ">"
          end
        else
          nil
        end
        idx = idx + 1
      end

      @tokens
    end
  end
end
