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
    # ...
  end
end
