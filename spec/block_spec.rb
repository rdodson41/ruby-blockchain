require 'block'
require 'timecop'

RSpec.describe Block do
  subject :block do
    described_class.new(parent_digest, transactions)
  end

  let :parent_digest do
    '0000cd49e9fd89270716a07412b68db6d4327461fc8f60534e58bb992aade068'
  end

  let :transactions do
    [
      { from: 'Alice', to: 'Bob',  amount: 10 },
      { from: 'Toby',  to: 'Adam', amount: 25 }
    ]
  end

  around do |example|
    Timecop.freeze('2018-06-14', &example)
  end

  describe '#mine!' do
    subject :mine! do
      block.mine!
    end

    let :expected_digest do
      '0000668fcdf2fe0ead8aaba9d21d76c4f447c1d43e89a89c2cce758e059288c6'
    end

    it 'changes the block digest' do
      expect { mine! }.to change(block, :digest).to(expected_digest)
    end
  end

  describe '#digest' do
    subject :digest do
      block.digest
    end

    let :expected_digest do
      '8bb37a0b53dc13353530ee849aec768a474407c5b2b622fae62225c4f19fa35b'
    end

    it 'is the block digest' do
      expect(digest).to eql(expected_digest)
    end
  end
end
