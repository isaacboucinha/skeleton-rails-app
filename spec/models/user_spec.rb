# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'model logic' do
    context 'on create' do
      it 'should not save user without name' do
        user = User.new
        expect(user.save).to be_falsy
      end

      it 'should not save user without password' do
        user = User.new(name: 'test')
        expect(user.save).to be_falsy
      end

      it 'should save user with valid fields' do
        user = User.new(name: 'test', password: 'test')
        expect(user.save).to be_truthy
      end

      it 'should hash user name on save' do
        user = User.create!(name: 'test', password: 'test')
        user.reload
        expect(user.name).to eq(Digest::MD5.hexdigest('test'))
      end

      it 'should encrypt password' do
        user = User.create!(name: 'test', password: 'test')
        expect(user.password_digest).not_to eq('test')
        expect(user.authenticate('test')).to be_truthy
      end

      it 'should not allow users with same name' do
        User.create!(name: 'test', password: 'test')
        another_user = User.new(name: 'test', password: 'another_test_password')
        expect(another_user.save).to be_falsy
      end

      it 'should allow users with same password, stored as different digests' do
        user = User.create!(name: 'test', password: 'test')
        another_user = User.new(name: 'another_test_password', password: 'test')
        expect(another_user.save!).to be_truthy

        user.reload
        another_user.reload

        expect(user.password_digest).not_to eq(another_user.password_digest)
      end
    end

    context 'associations' do
      let(:user) { create(:user) }

      describe 'with accounts' do
        it 'allows one association' do
          create(:user_account, user:)

          user.reload
          expect(user.accounts.empty?).to be(false)
        end

        it 'allows multiple associations' do
          create(:user_account, user:)
          create(:user_account, user:)

          user.reload
          expect(user.accounts.empty?).to be(false)
        end

        it 'should not show accounts from deleted associations' do
          user_account = create(:user_account, user:)

          user_account.destroy!
          user.reload
          expect(user.accounts.empty?).to be(true)
        end

        it 'should not show deleted accounts' do
          account = create(:account)
          create(:user_account, user:, account:)

          account.destroy!
          user.reload
          expect(user.accounts.empty?).to be(true)
        end
      end

      describe 'with wallets' do
        it 'allows one association' do
          create(:wallet, user:)

          user.reload
          expect(user.wallets.empty?).to be(false)
        end

        it 'allows multiple associations' do
          create(:wallet, user:)
          create(:wallet, user:)

          user.reload
          expect(user.wallets.empty?).to be(false)
        end

        it 'should not show deleted wallets' do
          wallet = create(:wallet, user:)

          wallet.destroy!
          user.reload
          expect(user.wallets.empty?).to be(true)
        end
      end
    end

    context 'on delete' do
      let(:user) { create(:user) }

      before(:each) do
        user.destroy!
      end

      it 'deletes the instance' do
        expect(user.persisted?).to be(false)
        expect(User.all).to eq([])
      end
    end
  end
end
