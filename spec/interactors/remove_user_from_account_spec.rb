# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveUserFromAccount do
  context 'when given valid credentials' do
    let(:user) { User.create!(name: 'test', password: 'test') }
    let(:account) { Account.create!(name: 'Test123') }
    subject(:context) { described_class.call(user:, account:) }

    it 'succeeds if association exists' do
      Wallet.create!(user_id: user.id, account_id: account.id, active: true)
      expect(context).to be_a_success
    end

    it 'fails if association exists, but is inactive' do
      Wallet.create!(user_id: user.id, account_id: account.id, active: false)

      expect(context.error).to be_present
      expect(context).to be_a_failure
    end

    it 'fails if association does not exist' do
      expect(context.error).to be_present
      expect(context).to be_a_failure
    end
  end

  context 'when given invalid credentials' do
    subject(:context) do
      described_class.call(user: User.new(name: 'test', password: 'test'), account: Account.new(name: 'Test123'))
    end

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
