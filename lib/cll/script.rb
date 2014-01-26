module CLL
  class Script
    attr_reader :instructions, :stack, :memory, :storage

    # Initialize a new +Script+.
    #
    # @param instructions [Array<Array, Symbol>] array of instructions
    # @param storage [Hash] contract storage
    def initialize(instructions, storage)
      @instructions = instructions.map { |op, *args| [op, *args.map { |arg| Value.value_for_raw(arg) }] }
      @storage = storage
      reset!
    end

    def should_stop?
      @stop || @pointer == instructions.size
    end

    # Stop execution of the script.
    #
    # @return [void]
    def stop!
      @stop = true
    end

    # Execute the script.
    #
    # @return [Value]
    def execute
      run_next until should_stop?
      stack.pop
    end

    # Run next instruction and move the pointer.
    #
    # @return [void]
    def run_next
      execute_instruction instructions[@pointer]
      @pointer += 1
    end

    # Execute instruction.
    #
    # @param [Array] instruction
    # @return [void]
    def execute_instruction(instruction)
      op, *args = instruction
      OPS[op].new(self, stack, storage).call(*args)
    end

    # Reset script execution status.
    #
    # @return [void]
    def reset!
      @stack = Containers::Stack.new
      @pointer = 0
      @stop = false
      @memory = {}
    end
  end
end
