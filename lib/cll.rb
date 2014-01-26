require 'algorithms'
require 'singleton'

require 'cll/op'
require 'cll/value'
require 'cll/script'
require 'cll/contract'
require 'cll/version'

module CLL
  OPS = {
    PUSH:   Op.op { |thing| stack.push(thing) },
    POP:    Op.op { stack.pop },
    POP:    Op.op { stack.pop },
    ADD:    Op.op { stack.push(stack.pop + stack.pop) },
    MUL:    Op.op { stack.push(stack.pop * stack.pop) },
    SUB:    Op.op { stack.push(stack.pop - stack.pop) },
    DIV:    Op.op { stack.push(stack.pop / stack.pop) },
    LT:     Op.op { stack.push(stack.pop < stack.pop) },
    GT:     Op.op { stack.push(stack.pop > stack.pop) },
    EQ:     Op.op { stack.push(stack.pop == stack.pop) },
    NOT:    Op.op { stack.push(stack.pop.not) },
    STOP:   Op.op { script.stop! },
    MSTORE: Op.op { |name| script.memory[name.val] = stack.pop },
    MLOAD:  Op.op { |name| stack.push(script.memory[name.val]) },
    SSET:   Op.op { storage[stack.pop.val] = stack.pop },
    SGET:   Op.op { stack.push(storage[stack.pop.val]) }
  }
end
