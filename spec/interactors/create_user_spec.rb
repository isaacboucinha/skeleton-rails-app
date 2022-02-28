# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateUser do
  context 'when given valid credentials' do
    subject(:context) { described_class.call(name: 'test', password: 'test') }

    let(:user) { double(:user, name: 'test', password: 'test') }

    before do
      allow(User).to receive(:create!).and_return(user)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the user' do
      expect(context.user).to eq(user)
      expect(context.user.name).to eq('test')
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
