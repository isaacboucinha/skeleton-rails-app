# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteAccount do
  subject(:context) { described_class.call(name: 'test') }

  context 'when given valid credentials' do
    let(:account) { double(:account, name: 'test') }

    before do
      allow(Account).to receive(:find_by).and_return(account)
    end

    it 'succeeds' do
      expect(account).to receive(:destroy)
      expect(context).to be_a_success
    end
  end

  context 'when given invalid credentials' do
    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
