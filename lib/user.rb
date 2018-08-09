require 'block'

class User
  attr_reader :blockchain
  attr_reader :name

  def initialize(blockchain, name, initial_balance)
    @blockchain = blockchain
    @name = name
    block = Block.new(blockchain.head_digest, [{ from: nil, to: name, amount: initial_balance }])
    block.mine!
    blockchain.add_block!(block)
  end

  # user should only be able to send if their balance will not go negative
  def send!(user, amount)
    block = Block.new(blockchain.head_digest, [{from: name, to: user.name, amount: amount}])
    block.mine!
    blockchain.add_block!(block)
  end
end
