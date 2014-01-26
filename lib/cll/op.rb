module CLL
  # A script operation.
  class Op
    class << self
      # Generate a new operation class with block as operation body.
      #
      # @param body [Proc] operation body
      # @return [Class] operation class
      def op(&body)
        Class.new(Op).with_body(body)
      end

      # @return [Class]
      def with_body(body)
        @body = body
        self
      end

      # @return [Proc]
      def body
        @body
      end
    end

    attr_reader :script, :stack, :storage

    # Initialize a new +Operation+.
    #
    # @param script [Script]
    # @param stack [Containers::Stack]
    # @param storage [Hash]
    def initialize(script, stack, storage)
      @script = script
      @stack = stack
      @storage = storage
    end

    # Call the operation and pass the args.
    #
    # @param args [Array] operation arguments
    def call(*args)
      instance_exec(*args, &self.class.body)
    end
  end
end
