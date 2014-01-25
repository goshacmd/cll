module CLL
  # A script operation.
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
end
