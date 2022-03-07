# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe UserAccount, type: :model do
  describe 'model logic' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:account1) { create(:account) }
    let(:account2) { create(:account) }

    it 'should not exist without a user association' do
      user_account = UserAccount.new(account_id: account1)
      expect(user_account.save).to be_falsy
    end

    it 'should not exist without an account association' do
      user_account = UserAccount.new(user_id: user1)
      expect(user_account.save).to be_falsy
    end

    it 'should associate a user to an account' do
      user_account = UserAccount.new(user_id: user1.id, account_id: account1.id)
      expect(user_account.save).to be_truthy
    end

    it 'should associate a user to several accounts' do
      user_account1 = UserAccount.new(user_id: user1.id, account_id: account1.id)
      user_account2 = UserAccount.new(user_id: user1.id, account_id: account2.id)

      expect(user1.accounts.size).to be(0)
      expect(user_account1.save).to be_truthy
      expect(user_account2.save).to be_truthy
      user1.reload
      expect(user1.accounts.size).to be(2)
    end

    it 'should associate an account to several users' do
      user_account1 = UserAccount.new(user_id: user1.id, account_id: account1.id)
      user_account2 = UserAccount.new(user_id: user2.id, account_id: account1.id)

      expect(account1.users.size).to be(0)
      expect(user_account1.save).to be_truthy
      expect(user_account2.save).to be_truthy
      account1.reload
      expect(account1.users.size).to be(2)
    end

    it 'should not allow repeated associations' do
      user_account1 = UserAccount.new(user_id: user1.id, account_id: account1.id)
      expect(user_account1.save).to be_truthy

      user_account2 = UserAccount.new(user_id: user1.id, account_id: account1.id)
      expect(user_account2.save).to be_falsy
    end

    context 'on discard' do
      let(:user_account) { create(:user_account) }

      before(:each) do
        user_account.discard
      end

      it 'discards the instance' do
        expect(user_account.discarded?).to be(true)
        expect(user_account.discarded_at).to be_truthy
        expect(UserAccount.kept).to eq([])
      end
    end
  end
end
