module Vvdc
  class Token
    def initialize(type, literal)
      @type = type
      @literal = literal
    end

    attr_reader :type
    attr_reader :literal

    @@keywords = {
      "if" => :keyword_if, "print" => :keyword_print, "while" => :keyword_while,
      "return" => :keyword_return, "let" => :keyword_let, "fn" => :keyword_fn
    }

    def self.keywords
      @@keywords
    end
  end

  class Lexer
    def initialize
      @idx = 0
      @program = []
      @tokens = []
    end

    def add(type, symbol, advance = 0)
      @tokens << Token.new(type, symbol)
      @idx += advance
    end

    def add_symbol(literal, advance = 1)
      add(:symbol, literal, advance)
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

    def peek_char_is(ch)
      @idx + 1 < @program.length && @program[@idx + 1] == ch
    end

    def scan(program)
      @program = program.chars
      while @idx < @program.length
        case @program[@idx]
        when " "
          @idx += 1
        when "+"
          add_symbol("+")
        when "-"
          add_symbol("-")
        when "*"
          add_symbol("*")
        when ";"
          add_symbol(";")
        when "("
          add_symbol("(")
        when ")"
          add_symbol(")")
        when "{"
          add_symbol("{")
        when "}"
          add_symbol("}")
        when "="
          if peek_char_is("=")
            add_symbol("==", 2)
          else
            add_symbol("=")
          end
        when "!"
          if peek_char_is("=")
            add_symbol("!=", 2)
          else
            add_symbol("!")
          end
        when "<"
          if peek_char_is("=")
            add_symbol("<=", 2)
          else
            add_symbol("<")
          end
        when ">"
          if peek_char_is("=")
            add_symbol(">=", 2)
          else
            add_symbol(">")
          end
        else
          if @program[@idx] == "\""
            st = ""
            @idx += 1
            while @idx < program.length && @program[@idx] != "\""
              st << program[@idx]
              @idx += 1
            end
            add(:string, st, 1) # add one for the final "
          elsif digit?(@program[@idx])
            numb = @program[@idx]
            @idx += 1
            while @idx < program.length && digit?(@program[@idx])
              numb << program[@idx]
              @idx += 1
            end
            add(:number, numb)
          else # Must be an identifier
            ident = @program[@idx]
            @idx += 1
            while @idx < program.length && identifier_char?(@program[@idx])
              ident << program[@idx]
              @idx += 1
            end
            type = Token.keywords[ident] || :identifier
            add(type, ident)
          end
        end
      end

      @tokens
    end
  end
end
