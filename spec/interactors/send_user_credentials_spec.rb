# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendUserCredentials do
  context 'when given valid credentials' do
    let(:user) { User.create!(name: 'test', password: 'test') }

    subject(:context) { described_class.call(user:) }

    before(:each) do
      allow_any_instance_of(IO).to receive(:write).and_return(nil)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'logs sending message' do
      expect($stdout).to receive(:puts).with('Sending credentials via email. Check them there!')
      context
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
