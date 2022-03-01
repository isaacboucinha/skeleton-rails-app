# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAccount do
  context 'when given valid credentials' do
    let(:account) { build(:account) }

    before(:each) do
      allow(Account).to receive(:create!).and_return(account)
    end

    subject(:context) { described_class.call(name: 'test') }

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'creates an account' do
      expect(context.account).to eq(account)
    end
  end

  context 'when given invalid credentials' do
    subject(:context) { described_class.call }

    it 'fails' do
      expect(context).to be_a_failure
      expect { context }.not_to(change { Account.count })
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
