module Vvdc
  class Expression
    def initialize(token)
      @token = token
      @value = token.literal
    end

    def to_s
      @value
    end

    attr_reader :token
    attr_reader :value
  end

  class NumericExpression < Expression
    def initialize(token)
      @token = token
      @value = Integer(token.literal)
    end
  end

  class StringExpression < Expression
  end

  class IdentifierExpression < Expression
  end

  class NegationExpression < Expression
    def initialize(token, right)
      @token = token
      @value = nil
      @right = right
    end

    attr_reader :right
  end

  class Parser
    def initialize
      @idx = 0
      @tokens = []
      @expressions = []
    end

    def parse(tokens)
      @tokens = tokens

      while @tokens[@idx]
        @expressions << parse_expression(@idx)
      end

      @expressions
    end

    def parse_expression(from)
      token = @tokens[from]
      if token.nil? then return end

      exp = nil
      case token.type
      when :number
        exp = NumericExpression.new(token)
        @idx += 1
      when :string
        exp = StringExpression.new(token)
        @idx += 1
      when :identifier
        exp = IdentifierExpression.new(token)
        @idx += 1
      when :symbol
        exp = parse_symbol(from)
      else
        @idx += 1
      end
      exp
    end

    def parse_symbol(from)
      exp = nil
      token = @tokens[from]
      case token.literal
      when "!"
        right = parse_expression(from + 1)
        exp = NegationExpression.new(token, right)
        @idx += 2
      else
        @idx += 1
      end
      exp
    end
  end
end
