module Vvdc
  class Expression
    def initialize(token)
      @token = token
      @value = token.literal
    end

    def to_s
      @value.to_s
    end

    def inspect
      to_s
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

  class AdditionExpression < Expression
    def initialize(token, left, right)
      @token = token
      @value = nil
      @left = left
      @right = right
    end

    def to_s
      "+"
    end

    def inspect
      "[#{@left.inspect} + #{@right.inspect}]"
    end

    attr_reader :left
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
        exp, adv = parse_expression(@idx)
        @expressions << exp unless exp.nil?
        @idx += adv
      end

      @expressions
    end

    def parse_expression(from)
      token = @tokens[from]
      if token.nil? then return end

      exp = nil
      adv = 0
      case token.type
      when :number
        left = NumericExpression.new(token)
        next_token = @tokens[from + 1]
        if next_token && next_token.literal == "+"
          right, adv_right = parse_expression(from + 2)
          exp = AdditionExpression.new(next_token, left, right)
          adv = 2 + adv_right
        else
          exp = left
          adv = 1
        end
      when :string
        exp = StringExpression.new(token)
        adv = 1
      when :identifier
        exp = IdentifierExpression.new(token)
        adv = 1
      when :symbol
        exp, adv = parse_symbol(from)
      else
        adv = 1
      end
      [exp, adv]
    end

    def parse_symbol(from)
      exp = nil
      adv = 0
      token = @tokens[from]
      case token.literal
      when "!"
        right, adv_right = parse_expression(from + 1)
        exp = NegationExpression.new(token, right)
        adv = 1 + adv_right
      when "+"
        right = parse_expression(from + 1)
        exp = NegationExpression.new(token, right)
        adv = 2
      else
        adv = 1
      end
      [exp, adv]
    end
  end
end
