# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAccount do
  context 'when given valid credentials' do
    subject(:context) { described_class.call(name: 'Test123') }

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'creates an account' do
      expect { context }.to change { Account.count }.from(0).to(1)
    end

    it 'provides the account' do
      expect(context.account.name).to eq('Test123')
    end
  end

  context 'when given invalid credentials' do
    subject(:context) { described_class.call(name: 'test') }

    it 'fails' do
      expect(context).to be_a_failure
      expect { context }.not_to(change { Account.count })
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
