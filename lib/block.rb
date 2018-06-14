require 'digest'
require 'json'

class Block
  attr_reader :parent_digest
  attr_reader :transactions
  attr_reader :time
  attr_reader :nonce

  def initialize(parent_digest = nil, transactions = [])
    @parent_digest = parent_digest
    @transactions = transactions
    @time = Time.now
    @nonce = 0
  end

  #
  # Proof-of-work (PoW) is a demonstration of having spent time and computing
  # power to complete a task.
  #
  # In the case of Bitcoin, this process is informally known as "mining", and
  # the task in question is to calculate a SHA256 digest, or "hash", which
  # starts with a certain number of zeroes.
  #
  # For example:
  #
  #    0000668fcdf2fe0ead8aaba9d21d76c4f447c1d43e89a89c2cce758e059288c6
  #
  # For our purposes, we'll set the required number of zeroes to 4.
  #
  def mine!(difficulty = 4)
    @nonce += 1 until valid?(difficulty)
  end

  def digest
    Digest::SHA256.hexdigest(to_s)
  end

  def to_s
    JSON.pretty_generate(to_h)
  end

  def to_h
    {
      parent_digest: parent_digest,
      transactions: transactions,
      time: time,
      nonce: nonce
    }
  end

  def valid?(difficulty = 4)
    digest.start_with?('0' * difficulty)
  end
end
