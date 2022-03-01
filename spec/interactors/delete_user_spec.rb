# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteUser do
  subject(:context) { described_class.call(name: 'test') }

  context 'when given valid credentials' do
    let(:user) { build(:user) }

    before do
      allow(User).to receive(:find_by).and_return(user)
    end

    it 'succeeds' do
      expect(user).to receive(:destroy)
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
