module CLL
  class Contract
    attr_reader :instructions, :storage

    # Initialize a new +Contract+.
    #
    # @param instructions [Array<Array>] array of instructions
    def initialize(instructions)
      @instructions = instructions
      @storage = {}
    end

    # Execute the script in the context of the contract.
    #
    # @return [void]
    def run_script
      Script.new(instructions, storage).execute
    end
  end
end
