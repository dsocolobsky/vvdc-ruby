module Vvdc
  class Token
    def initialize(type, literal)
      @type = type
      @literal = literal
    end

    attr_reader :type
    attr_reader :literal
  end

  class Lexer
    def initialize
      @tokens = []
    end

    def add(type, symbol)
      @tokens << Token.new(type, symbol)
    end

    def add_symbol(literal)
      add(:symbol, literal)
    end

    def digit?(ch)
      ch.ord >= 48 && ch.ord <= 57
    end

    def alphabetic?(ch)
      (ch.ord >= 65 && ch.ord <= 90) or (ch.ord >= 97 && ch.ord <= 122)
    end

    def identifier_char?(ch)
      alphabetic?(ch) || digit?(ch) || ch == "_"
    end

    def scan(program)
      idx = 0
      chars = program.chars
      while idx < chars.length
        case chars[idx]
        when " "
          idx += 1
        when "+"
          add_symbol("+")
          idx += 1
        when "-"
          add_symbol("-")
          idx += 1
        when "*"
          add_symbol("*")
          idx += 1
        when ";"
          add_symbol(";")
          idx += 1
        when "("
          add_symbol("(")
          idx += 1
        when ")"
          add_symbol(")")
          idx += 1
        when "{"
          add_symbol("{")
          idx += 1
        when "}"
          add_symbol("}")
          idx += 1
        when "="
          if idx + 1 < program.length && chars[idx + 1] == "="
            add_symbol("==")
            idx += 2
          else
            add_symbol("=")
            idx += 1
          end
        when "!"
          if idx + 1 < program.length && chars[idx + 1] == "="
            add_symbol("!=")
            idx += 2
          else
            add_symbol("!")
            idx += 1
          end
        when "<"
          if idx + 1 < program.length && chars[idx + 1] == "="
            add_symbol("<=")
            idx += 2
          else
            add_symbol("<")
            idx += 1
          end
        when ">"
          if idx + 1 < program.length && chars[idx + 1] == "="
            add_symbol(">=")
            idx += 2
          else
            add_symbol(">")
            idx += 1
          end
        else
          if chars[idx] == "\""
            st = ""
            idx += 1
            while idx < program.length && chars[idx] != "\""
              st << program[idx]
              idx += 1
            end
            idx += 1 # add one for the final "
            add(:string, st)
          elsif digit?(chars[idx])
            numb = chars[idx]
            idx += 1
            while idx < program.length && digit?(chars[idx])
              numb << program[idx]
              idx += 1
            end
            add(:number, numb)
          else # Must be an identifier
            ident = chars[idx]
            idx += 1
            while idx < program.length && identifier_char?(chars[idx])
              ident << program[idx]
              idx += 1
            end
            add(:identifier, ident)
          end
        end
      end

      @tokens
    end
  end
end
