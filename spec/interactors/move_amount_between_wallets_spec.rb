# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoveAmountBetweenWallets do
  context 'when given valid credentials' do
    let(:user) { User.create!(name: 'test', password: 'test') }
    let(:account1) { Account.create!(name: 'Test123') }
    let(:account2) { Account.create!(name: 'Test321') }
    let(:amount) { 1000 }

    let(:from_wallet) { Wallet.create!(user_id: user.id, account_id: account1.id) }
    let(:to_wallet) { Wallet.create!(user_id: user.id, account_id: account2.id) }

    subject(:context) { described_class.call(from_wallet:, to_wallet:, amount:) }

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'withdraws correctly' do
      expect { context }.to change { from_wallet.balance }.by(-amount)
    end

    it 'deposits correctly' do
      expect { context }.to change { to_wallet.balance }.by(amount)
    end
  end

  context 'when given invalid credentials' do
    subject(:context) do
      described_class.call()
    end

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
