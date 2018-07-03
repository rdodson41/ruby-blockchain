class Blockchain
  attr_reader :blocks

  def initialize(blocks = [])
    @blocks = blocks
  end

  def head
    blocks.last
  end

  def add_block!(block, difficulty = 4)
    blocks << block if block_valid?(block, difficulty)
  end

  #
  # Is the new block valid?
  #
  # Does its digest start with the required number of zeroes?
  #
  # Does its parent block digest match the blockchain head block digest?
  #
  # Does it include a "double spend": a transaction which would result in a
  # negative balance?
  #
  def block_valid?(block, difficulty = 4)
    block.valid?(difficulty) &&
      block.parent_digest == head.digest &&
      balances(block).none? { |user, balance| balance < 0 }
  end

  private

  def balances(block)
    balances = Hash.new(0)
    (blocks + [block]).each do |block|
      block.transactions.each do |transaction|
        balances[transaction[:from]] -= transaction[:amount] if transaction[:from]
        balances[transaction[:to]] += transaction[:amount]
      end
    end
    balances
  end
end
