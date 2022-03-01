# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoveAmountBetweenWallets do
  context 'when given valid credentials' do
    let(:user) { create(:user) }
    let(:account1) { create(:account) }
    let(:account2) { create(:account) }
    let(:amount) { 1000 }

    let(:from_wallet) { create(:wallet, user:, account: account1) }
    let(:to_wallet) { create(:wallet, user:, account: account2) }

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
      described_class.call
    end

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
