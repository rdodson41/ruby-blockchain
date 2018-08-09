require 'blockchain'
require 'user'

RSpec.describe User do
  subject :alice do
    described_class.new(blockchain, 'Alice', 25)
  end

  let :blockchain do
    Blockchain.new
  end

  let :bob do
    User.new(blockchain, 'Bob', 25)
  end

  describe '#send!' do
    subject :send! do
      alice.send!(bob, amount)
    end

    context 'with a valid amount' do
      let :amount do
        10
      end

      it 'does not raise an error' do
        expect { send! }.not_to raise_error
      end
    end

    context 'with an invalid amount' do
      let :amount do
        50
      end

      it 'raises an error' do
        expect { send! }.to raise_error('Invalid block')
      end
    end
  end
end
