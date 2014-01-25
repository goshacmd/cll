module CLL
  # A script operation.
  class Op
    class << self
      def op(&body)
        Class.new(Op).with_body(body)
      end

      def with_body(body)
        @body = body
        self
      end

      def body
        @body
      end
    end

    attr_reader :script, :stack

    def initialize(script, stack)
      @script = script
      @stack = stack
    end

    def call(*args)
      instance_exec(*args, &self.class.body)
    end
  end
end
