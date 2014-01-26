module CLL
  # Value on the stack.
  class Value
    class << self
      # Create a stack value object from raw Ruby value.
      #
      # @return [Value]
      def value_for_raw(raw)
        case raw
        when Integer then IntegerValue.new(raw)
        when String then StringValue.new(raw)
        when true, false then BoolValue.bool(raw)
        else
          raise ArgumentError, "unknown raw value type"
        end
      end
    end
  end

  class IntegerValue < Value
    attr_reader :val

    def initialize(raw)
      @val = raw.to_i
    end

    def +(other)
      self.class.new(val + other.val)
    end

    def -(other)
      self.class.new(val - other.val)
    end

    def >(other)
      BoolValue.bool(val > other.val)
    end

    def <(other)
      BoolValue.bool(val < other.val)
    end

    def ==(other)
      BoolValue.bool(val == other.val)
    end
  end

  class StringValue < Value
    attr_reader :val

    def initialize(raw)
      @val = raw.to_s
    end
  end

  class BoolValue < Value
    class << self
      def bool(bool)
        bool ? TrueValue.instance : FalseValue.instance
      end
    end
  end

  class TrueValue < BoolValue
    include Singleton

    def not
      FalseValue.instance
    end
  end

  class FalseValue < BoolValue
    include Singleton

    def not
      TrueValue.instance
    end
  end
end
