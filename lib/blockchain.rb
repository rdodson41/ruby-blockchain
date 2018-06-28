class Blockchain
  attr_reader :blocks

  def initialize(blocks = [])
    @blocks = blocks
  end

  def head
    blocks.last
  end

  def add_block!(block)
    blocks << block if block_valid?(block)
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
  def block_valid?(block)
    block.valid?(2) && block.parent_digest == head.digest && verify_transactions
  end

  def verify_transactions
    balances = Hash.new(0)

    blocks.each do |block|
      block.transactions.each do |transaction|
        balances[transaction[:from]] -= transaction[:amount] unless transaction[:from].nil?
        balances[transaction[:to]] += transaction[:amount]
      end
    end

    # loop through balances and see if any value is negative, except for key of nil
    puts balances
    balances.values.all? { |balance| balance >= 0 }
  end
end
