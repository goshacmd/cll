require 'cll'

contract = CLL::Contract.new(balance: 12) do
  push 1
  push "current_number"
  sget
  add
  push "current_number"
  sset
end

# equivalent to:
#
#   contract.storage.set("current_number", 1 + contract.storage.get("current_number"))

contract.run_script
puts contract.inspect
contract.run_script
puts contract.inspect
contract.run_script # should run out of balance
