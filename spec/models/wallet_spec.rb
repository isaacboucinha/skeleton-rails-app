# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'model logic' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'should not exist without a user association' do
      wallet = Wallet.new
      expect(wallet.save).to be_falsy
    end

    it 'should exist with a user association' do
      wallet = Wallet.new(user: user1)
      expect(wallet.save).to be_truthy
      expect(wallet.user).to be_truthy
    end

    it 'should have a currency and minimum balance by default' do
      wallet = Wallet.new(user_id: user1.id)
      expect(wallet.save).to be_truthy
      wallet.reload
      expect(wallet.balance).to eq(Globals::Amounts::MINIMUM_FOR_WALLET_CREATION)
      expect(wallet.currency).to eq('eur')
    end

    it 'should accept other currencies' do
      allow_any_instance_of(Wallet).to receive(:minimum_amount_for_creation)
        .and_return(true)

      wallet = Wallet.new(user_id: user1.id, currency: 'test')
      expect(wallet.save).to be_truthy
      expect(wallet.currency).to eq('test')
    end

    context 'on creation' do
      it 'should accept initial balance above minimum' do
        wallet = Wallet.new(user_id: user1.id, balance: Globals::Amounts::MINIMUM_FOR_WALLET_CREATION + 1)
        expect(wallet.save).to be_truthy
      end

      it 'should accept initial balance equal to minimum' do
        wallet = Wallet.new(user_id: user1.id, balance: Globals::Amounts::MINIMUM_FOR_WALLET_CREATION)
        expect(wallet.save).to be_truthy
      end

      it 'should not accept initial balance below minimum' do
        wallet = Wallet.new(user_id: user1.id, balance: Globals::Amounts::MINIMUM_FOR_WALLET_CREATION - 1)
        expect(wallet.save).to be_falsy
      end

      describe 'for currencies other than euro' do
        it 'should accept initial balance above, or equal to, minimum' do
          allow_any_instance_of(Wallet).to receive(:convert_to_euro)
            .and_return(Globals::Amounts::MINIMUM_FOR_WALLET_CREATION)

          wallet = Wallet.new(user_id: user1.id, currency: 'test', balance: 10)
          expect(wallet.save).to be_truthy
        end

        it 'should not accept initial balance below minimum, for different currencies' do
          allow_any_instance_of(Wallet).to receive(:convert_to_euro)
            .and_return(Globals::Amounts::MINIMUM_FOR_WALLET_CREATION - 1)

          wallet = Wallet.new(user_id: user1.id, currency: 'test', balance: 10)
          expect(wallet.save).to be_falsy
        end
      end
    end

    context 'on save' do
      it 'should accept balances between minimum and maximum' do
        wallet = Wallet.new(user_id: user1.id)
        expect(wallet.save).to be_truthy

        wallet.balance = Globals::Amounts::MINIMUM_BALANCE_FOR_WALLET
        expect(wallet.save).to be_truthy

        wallet.balance = Globals::Amounts::MAXIMUM_BALANCE_FOR_WALLET
        expect(wallet.save).to be_truthy
      end

      it 'should not accept balances below minimum' do
        wallet = Wallet.new(user_id: user1.id, balance: Globals::Amounts::MINIMUM_BALANCE_FOR_WALLET - 1)
        expect(wallet.save).to be_falsy
      end

      it 'should not accept balances above maximum' do
        wallet = Wallet.new(user_id: user1.id, balance: Globals::Amounts::MAXIMUM_BALANCE_FOR_WALLET + 1)
        expect(wallet.save).to be_falsy
      end

      describe 'for currencies other than euro' do
        it 'should accept balances between minimum and maximum' do
          wallet = Wallet.new(user_id: user1.id)
          wallet.save

          allow_any_instance_of(Wallet).to receive(:convert_to_euro)
            .and_return(Globals::Amounts::MINIMUM_BALANCE_FOR_WALLET)
          wallet.balance = -10
          expect(wallet.save).to be_truthy

          allow_any_instance_of(Wallet).to receive(:convert_to_euro)
            .and_return(Globals::Amounts::MAXIMUM_BALANCE_FOR_WALLET)
          wallet.balance = 100
          expect(wallet.save).to be_truthy
        end

        it 'should not accept balances below minimum' do
          wallet = Wallet.new(user_id: user1.id)
          allow_any_instance_of(Wallet).to receive(:convert_to_euro)
            .and_return(Globals::Amounts::MINIMUM_BALANCE_FOR_WALLET - 1)
          expect(wallet.save).to be_falsy
        end

        it 'should not accept balances above maximum' do
          wallet = Wallet.new(user_id: user1.id)
          allow_any_instance_of(Wallet).to receive(:convert_to_euro)
            .and_return(Globals::Amounts::MAXIMUM_BALANCE_FOR_WALLET + 1)
          expect(wallet.save).to be_falsy
        end
      end
    end

    context 'on delete' do
      let(:wallet) { create(:wallet) }

      before(:each) do
        wallet.destroy!
      end

      it 'deletes the instance' do
        expect(wallet.persisted?).to be(false)
        expect(Wallet.all).to eq([])
      end
    end
  end
end
