# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateUser do
  context 'when given valid credentials' do
    let(:user) { build(:user) }

    before(:each) do
      allow(User).to receive(:create!).and_return(user)
    end

    subject(:context) { described_class.call(name: 'test', password: 'test') }

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'creates a user' do
      expect(context.user).to eq(user)
    end
  end

  context 'when given invalid credentials' do
    subject(:context) { described_class.call(name: 'test') }

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
