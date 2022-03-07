# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteAccount do
  context 'when given valid credentials' do
    let(:account) { build(:account) }

    subject(:context) { described_class.call(account:) }

    it 'succeeds' do
      expect(account).to receive(:destroy)
      expect(context).to be_a_success
    end
  end

  context 'when given invalid credentials' do
    subject(:context) { described_class.call }

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
