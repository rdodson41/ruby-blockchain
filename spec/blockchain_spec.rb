require 'block'
require 'blockchain'
require 'timecop'

RSpec.describe Blockchain do
  subject :blockchain do
    described_class.new(blocks)
  end

  let :blocks do
    [
      block_0,
      block_1
    ]
  end

  let :block_0 do
    Block.new(nil, transactions_0)
  end

  let :block_1 do
    Block.new(block_0.digest, transactions_1)
  end

  let :transactions_0 do
    [
      { from: nil,     to: 'Alice', amount: 25 },
      { from: nil,     to: 'Bob',   amount: 25 },
      { from: nil,     to: 'Toby',  amount: 25 },
      { from: nil,     to: 'Adam',  amount: 25 }
    ]
  end

  let :transactions_1 do
    [
      { from: 'Alice', to: 'Bob',   amount: 10 },
      { from: 'Toby',  to: 'Adam',  amount: 25 }
    ]
  end

  let :difficulty do
    2
  end

  around do |example|
    Timecop.freeze('2018-06-14', &example)
  end

  before do
    block_0.mine!(difficulty)
    block_1.mine!(difficulty)
  end

  describe '#add_block!' do
    subject :add_block! do
      blockchain.add_block!(block, difficulty)
    end

    let :block do
      Block.new(parent_digest, transactions)
    end

    context 'when the block has an invalid digest' do
      let :parent_digest do
        block_1.digest
      end

      let :transactions do
        [
          { from: 'Alice', to: 'Bob', amount: 10 }
        ]
      end

      it 'raises an error' do
        expect { add_block! }.to raise_error('Invalid block')
      end
    end

    context 'when the block parent digest does not match the head digest' do
      let :parent_digest do
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
      end

      let :transactions do
        [
          { from: 'Alice', to: 'Bob', amount: 10 }
        ]
      end

      before do
        block.mine!(difficulty)
      end

      it 'raises an error' do
        expect { add_block! }.to raise_error('Invalid block')
      end
    end

    context 'when the block has an invalid transaction' do
      let :parent_digest do
        block_1.digest
      end

      let :transactions do
        [
          { from: 'Alice', to: 'Bob', amount: 50 }
        ]
      end

      before do
        block.mine!(difficulty)
      end

      it 'raises an error' do
        expect { add_block! }.to raise_error('Invalid block')
      end
    end

    context 'otherwise' do
      let :parent_digest do
        block_1.digest
      end

      let :transactions do
        [
          { from: 'Alice', to: 'Bob', amount: 10 }
        ]
      end

      before do
        block.mine!(difficulty)
      end

      it 'changes the blockchain blocks' do
        expect { add_block! }.to change(blockchain, :blocks).by([block])
      end
    end
  end

  describe '#head' do
    subject :head do
      blockchain.head
    end

    it 'is the blockchain head' do
      expect(head).to be(block_1)
    end
  end
end
