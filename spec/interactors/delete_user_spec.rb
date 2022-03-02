# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteUser do
  context 'when given valid credentials' do
    let(:user) { build(:user) }

    subject(:context) { described_class.call(user:) }

    it 'succeeds' do
      expect(user).to receive(:delete)
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
