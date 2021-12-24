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

  class Parser
    def initialize
      @tokens = []
      @expressions = []
    end

    def parse(tokens)
      @tokens = tokens

      tokens.each do |token|
        case token.type
        when :number
          @expressions << NumericExpression.new(token)
        when :string
          @expressions << StringExpression.new(token)
        when :identifier
          @expressions << IdentifierExpression.new(token)
        end
      end
      @expressions
    end
  end
end
