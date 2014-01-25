require 'algorithms'
require 'singleton'

require 'cll/version'

module Cll
  class Op
    def self.op(&body)
      Class.new(Op).with_body(body)
    end

    def self.with_body(body)
      @@body = body
      self
    end

    attr_reader :script, :stack

    def initialize(script, stack)
      @script = script
      @stack = stack
    end

    def call(*args)
      instance_exec(*args, &@@body)
    end
  end

  OPS = {
    PUSH: Op.op { |thing| stack.push(thing) },
    POP: Op.op { stack.pop },
    POP: Op.op { stack.pop },
    ADD: Op.op { stack.push(stack.pop + stack.pop) },
    MUL: Op.op { stack.push(stack.pop * stack.pop) },
    SUB: Op.op { stack.push(stack.pop - stack.pop) },
    DIV: Op.op { stack.push(stack.pop / stack.pop) },
    LT: Op.op { stack.push(stack.pop < stack.pop) },
    GT: Op.op { stack.push(stack.pop > stack.pop) },
    EQ: Op.op { stack.push(stack.pop == stack.pop) },
    NOT: Op.op { stack.push(stack.pop.not) },
    STOP: Op.op { script.stop! }
  }

  class Value
    class << self
      def value_for_raw(raw)
        case raw
        when Integer then IntegerValue.new(raw)
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

  class Script
    # Initialize a new +Script+.
    #
    # @param instructions [Array<Array, Symbol>] array of instructions
    def initialize(instructions)
      @instructions = instructions.map { |op, *args| [op, *args.map { |arg| Value.value_for_raw(arg) }] }
      reset!
    end

    def should_stop?
      @stop || @pointer == @instructions.size
    end

    def stop!
      @stop = true
    end

    # Execute the script.
    def execute
      run_next until should_stop?
      @stack.pop
    end

    # Run next instruction and move the pointer.
    def run_next
      execute_instruction @instructions[@pointer]
      @pointer += 1
    end

    # Execute instruction.
    #
    # @param [Array] instruction
    def execute_instruction(instruction)
      op, *args = instruction
      OPS[op].new(self, @stack).call(*args)
    end

    # Reset script execution status.
    def reset!
      @stack = Containers::Stack.new
      @pointer = 0
      @stop = false
    end
  end
end
