# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoveUserFromAccount do
  context 'when given valid credentials' do
    let(:user) { create(:user) }
    let(:account) { create(:account) }
    subject(:context) { described_class.call(user:, account:) }

    it 'succeeds if association exists' do
      create(:wallet, user:, account:)
      expect(context).to be_a_success
    end

    it 'fails if association exists, but is inactive' do
      wallet = create(:wallet, user:, account:)
      wallet.discard

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
