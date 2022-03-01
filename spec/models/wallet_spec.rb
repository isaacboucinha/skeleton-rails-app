# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'model logic' do
    let(:user1) { User.create!(name: 'user1', password: 'test') }
    let(:user2) { User.create!(name: 'user2', password: 'test') }
    let(:account1) { Account.create!(name: 'Account1') }
    let(:account2) { Account.create!(name: 'Account2') }

    it 'should not exist without a user association' do
      wallet = Wallet.new(user_id: user1)
      expect(wallet.save).to be_falsy
    end

    it 'should not exist without an account association' do
      wallet = Wallet.new(account_id: account1)
      expect(wallet.save).to be_falsy
    end

    it 'should associate a user to an account' do
      wallet = Wallet.new(user_id: user1.id, account_id: account1.id)
      expect(wallet.save).to be_truthy
    end

    it 'should associate a user to several accounts' do
      wallet1 = Wallet.new(user_id: user1.id, account_id: account1.id)
      wallet2 = Wallet.new(user_id: user1.id, account_id: account2.id)

      expect(user1.accounts.size).to be(0)
      expect(wallet1.save).to be_truthy
      expect(wallet2.save).to be_truthy
      user1.reload
      expect(user1.accounts.size).to be(2)
    end

    it 'should associate an account to several users' do
      wallet1 = Wallet.new(user_id: user1.id, account_id: account1.id)
      wallet2 = Wallet.new(user_id: user2.id, account_id: account1.id)

      expect(account1.users.size).to be(0)
      expect(wallet1.save).to be_truthy
      expect(wallet2.save).to be_truthy
      account1.reload
      expect(account1.users.size).to be(2)
    end

    it 'should not allow repeated associations' do
      wallet1 = Wallet.new(user_id: user1.id, account_id: account1.id)
      expect(wallet1.save).to be_truthy

      wallet2 = Wallet.new(user_id: user1.id, account_id: account1.id)
      expect(wallet2.save).to be_falsy
    end

    # SMELL change values in sections below to something less static

    it 'should have a currency and minimum balance by default' do
      wallet = Wallet.new(user_id: user1.id, account_id: account1.id)
      expect(wallet.save).to be_truthy
      wallet.reload
      expect(wallet.balance).to eq(1000)
      expect(wallet.currency).to eq('eur')
    end

    it 'should accept other currencies' do
      wallet = Wallet.new(user_id: user1.id, account_id: account1.id, currency: 'test', balance: 10_000)
      expect(wallet.save).to be_truthy
      expect(wallet.balance).to eq(10_000)
      expect(wallet.currency).to eq('test')
    end

    context 'on creation' do
      it 'should accept initial balance above 1000 euros' do
        wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: 1100)
        expect(wallet.save).to be_truthy
      end

      it 'should accept initial balance equal to 1000 euros' do
        wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: 1100)
        expect(wallet.save).to be_truthy
      end

      it 'should not accept initial balance below 1000 euros' do
        wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: 999)
        expect(wallet.save).to be_falsy
      end

      describe 'for currencies other than euro' do
        it 'should accept initial balance above, or equal to, 1000 euros' do
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(1000)

          wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: 10)
          expect(wallet.save).to be_truthy
        end

        it 'should not accept initial balance below 1000 euros, for different currencies' do
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(999)

          wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: 10)
          expect(wallet.save).to be_falsy
        end
      end
    end

    context 'on save' do
      it 'should accept balances between -100.000 and 1.000.000' do
        wallet = Wallet.new(user_id: user1.id, account_id: account1.id)
        expect(wallet.save).to be_truthy

        wallet.balance = -100_000
        expect(wallet.save).to be_truthy

        wallet.balance = 1_000_000
        expect(wallet.save).to be_truthy
      end

      it 'should not accept balances below -100.000' do
        wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: -100_001)
        expect(wallet.save).to be_falsy
      end

      it 'should not accept balances above 1.000.000' do
        wallet = Wallet.new(user_id: user1.id, account_id: account1.id, balance: 1_000_001)
        expect(wallet.save).to be_falsy
      end

      describe 'for currencies other than euro' do
        it 'should accept balances between -100.000 and 1.000.000' do
          wallet = Wallet.new(user_id: user1.id, account_id: account1.id)
          wallet.save

          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(-100_000)
          wallet.balance = -10
          expect(wallet.save).to be_truthy

          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(1_000_000)
          wallet.balance = 100
          expect(wallet.save).to be_truthy
        end

        it 'should not accept balances below -100.000' do
          wallet = Wallet.new(user_id: user1.id, account_id: account1.id)
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(-100_001)
          expect(wallet.save).to be_falsy
        end

        it 'should not accept balances above 1.000.000' do
          wallet = Wallet.new(user_id: user1.id, account_id: account1.id)
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(1_000_001)
          expect(wallet.save).to be_falsy
        end
      end
    end
  end
end
