module CLL
  class Script
    attr_reader :instructions, :stack, :memory, :storage, :contract

    # Initialize a new +Script+.
    #
    # @param instructions [Array<Array, Symbol>] array of instructions
    # @param storage [Storage] contract storage
    # @param contract [Contract]
    def initialize(instructions, storage, contract)
      @instructions = instructions.map { |op, *args| [op, *args.map { |arg| Value.value_for_raw(arg) }] }
      @storage = storage
      @contract = contract
      reset!
    end

    def should_stop?
      @stop || @pointer == instructions.size
    end

    # Get the price of operation.
    #
    # @param op [Symbol] operation name
    def price_of_op(op)
      1
    end

    # Stop execution of the script.
    #
    # @return [void]
    def stop!
      @stop = true
    end

    def can_execute?(op)
      contract.balance >= price_of_op(op)
    end

    # Execute the script.
    #
    # @return [Value]
    def execute
      until should_stop?
        run_next
      end

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

      unless can_execute?(op)
        raise RuntimeError, 'Contract ran out of balance'
      end

      contract.balance -= price_of_op(op)
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
