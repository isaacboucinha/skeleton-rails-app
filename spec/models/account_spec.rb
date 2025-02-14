# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'model logic' do
    context 'on create' do
      it 'should not save account without name' do
        account = Account.new
        expect(account.save).to be_falsy
      end

      it 'should not save account without lower case letters in name' do
        account = Account.new(name: 'TEST123')
        expect(account.save).to be_falsy
      end

      it 'should not save account without upper case letters in name' do
        account = Account.new(name: 'test123')
        expect(account.save).to be_falsy
      end

      it 'should not save account without digits in name' do
        account = Account.new(name: 'Testtest')
        expect(account.save).to be_falsy
      end

      it 'should not save account with less than 5 chars' do
        # less than 5 characters
        account = Account.new(name: 'Tes1')
        expect(account.save).to be_falsy
        account = Account.new(name: 'Test1')
        expect(account.save).to be_truthy
      end

      it 'should not save account with more than 15 chars' do
        # more than 15 characters
        account = Account.new(name: 'Thisismorethan15characters')
        expect(account.save).to be_falsy
        account = Account.new(name: 'Exaactly15chars')
        expect(account.save).to be_truthy
      end

      it 'should save account with valid name' do
        account = Account.new(name: 'Test123')
        expect(account.save).to be_truthy
      end

      it 'should not allow accounts with same name' do
        account = Account.new(name: 'Test123')
        account.save!

        another_account = Account.new(name: 'Test123')
        expect(another_account.save).to be_falsy

        # test case insensitivity
        another_account = Account.new(name: 'TesT123')
        expect(another_account.save).to be_falsy
      end
    end

    context 'associations' do
      let(:account) { create(:account) }

      describe 'with users' do
        it 'allows one association' do
          create(:user_account, account:)

          account.reload
          expect(account.users.empty?).to be(false)
        end

        it 'allows multiple associations' do
          create(:user_account, account:)
          create(:user_account, account:)

          account.reload
          expect(account.users.empty?).to be(false)
        end

        it 'should not show users from discarded associations' do
          create(:user_account, account:, discarded_at: DateTime.now)

          account.reload
          expect(account.users.empty?).to be(true)
        end

        it 'should not show discarded users' do
          user = create(:user, discarded_at: DateTime.now)
          create(:user_account, user:, account:)

          account.reload
          expect(account.users.empty?).to be(true)
        end
      end
    end

    context 'on discard' do
      let(:account) { create(:account) }

      before(:each) do
        account.discard
      end

      it 'discards the instance' do
        expect(account.discarded?).to be(true)
        expect(account.discarded_at).to be_truthy
        expect(Account.kept).to eq([])
      end
    end
  end
end
