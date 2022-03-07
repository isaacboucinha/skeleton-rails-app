# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddUserToAccount do
  context 'when given valid credentials' do
    before(:each) do
      @user = create(:user)
      @account = create(:account)
    end

    subject(:context) { described_class.call(user: @user, account: @account) }

    it 'succeeds if no association exists' do
      expect(context).to be_a_success
      expect(context.user_account).to be_present
    end

    it 'succeeds if association already exists, but is inactive' do
      user_account = create(:user_account, user: @user, account: @account)
      user_account.destroy

      expect(context).to be_a_success
      expect(context.user_account).to be_present
    end

    it 'fails if association already exists and is active' do
      create(:user_account, user: @user, account: @account)

      expect(context.error).to be_present
      expect(context).to be_a_failure
    end
  end

  context 'when given invalid credentials' do
    subject(:context) do
      described_class.call(user: User.new(name: 'test', password: 'test'), account: Account.new(name: 'Test123'))
    end

    it 'fails' do
      expect(context).to be_a_failure
    end

    it 'provides a failure message' do
      expect(context.error).to be_present
    end
  end
end
