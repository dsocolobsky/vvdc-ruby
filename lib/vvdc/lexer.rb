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
      self.add(:symbol, literal)
    end

    def digit?(ch)
      48 <= ch.ord and ch.ord <= 57
    end

    def alphabetic?(ch)
      (65 <= ch.ord and ch.ord <= 90) or (97 <= ch.ord and ch.ord <= 122)
    end

    def identifier_char?(ch)
      self.alphabetic?(ch) or self.digit?(ch) or ch == "_"
    end

    def scan(program)
      idx = 0
      chars = program.split('')
      while idx < chars.length
        case chars[idx]
        when " "
          nil
        when "+"
          self.add_symbol("+")
        when "-"
          self.add_symbol("-")
        when "*"
          self.add_symbol("*")
        when ";"
          self.add_symbol(";")
        when "("
          self.add_symbol("(")
        when ")"
          self.add_symbol(")")
        when "{"
          self.add_symbol("{")
        when "}"
          self.add_symbol("}")
        when "="
          if idx + 1 < program.length and chars[idx+1] == "="
            self.add_symbol("==")
            idx = idx + 1
          else
            self.add_symbol("=")
          end
        when "!"
          if idx + 1 < program.length and chars[idx+1] == "="
            self.add_symbol("!=")
            idx = idx + 1
          else
            self.add_symbol("!")
          end
        when "<"
          if idx + 1 < program.length and chars[idx+1] == "="
            self.add_symbol("<=")
            idx = idx + 1
          else
            self.add_symbol("<")
          end
        when ">"
          if idx + 1 < program.length and chars[idx+1] == "="
            self.add_symbol(">=")
            idx = idx + 1
          else
            self.add_symbol(">")
          end
        else
          if chars[idx] == "\""
            st = ""
            idx = idx + 1
            while idx < program.length and chars[idx] != "\""
              st << program[idx]
              idx = idx + 1
            end
            self.add(:string, st)
          elsif self.digit?(chars[idx])
            numb = chars[idx]
            idx = idx + 1
            while idx < program.length and self.digit?(chars[idx])
              numb << program[idx]
              idx = idx + 1
            end
            self.add(:number, numb)
          else  # Must be an identifier
            ident = chars[idx]
            idx = idx + 1
            while idx < program.length and self.identifier_char?(chars[idx])
              ident << program[idx]
              idx = idx + 1
            end
            self.add(:identifier, ident)
          end
        end
        idx = idx + 1
      end

      @tokens
    end
  end
end
