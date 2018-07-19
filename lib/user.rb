require 'block'

class User
  attr_reader :blockchain
  attr_reader :name

  def initialize(blockchain, name, initial_balance)
    @blockchain = blockchain
    @name = name
    # ...
  end

  def send!(user, amount)
    # ...
  end
end
