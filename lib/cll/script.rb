module CLL
  class Script
    attr_reader :memory

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
      @memory = {}
    end
  end
end
