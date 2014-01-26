module CLL
  class Contract
    class InstructionBuilder
      attr_reader :instructions

      def initialize(&block)
        @instructions = []
        instance_exec(&block)
      end

      def method_missing(name, *args)
        if OPS[name.upcase]
          @instructions << [name.upcase.to_sym, *args]
        else
          super
        end
      end
    end

    attr_reader :instructions, :storage

    # Initialize a new +Contract+.
    #
    # @param instructions [Array<Array>] array of instructions
    def initialize(instructions = nil, &block)
      if block_given?
        @instructions = InstructionBuilder.new(&block).instructions
      else
        @instructions = instructions
      end

      @storage = Storage.new
    end

    # Execute the script in the context of the contract.
    #
    # @return [void]
    def run_script
      Script.new(instructions, storage).execute
    end
  end
end
