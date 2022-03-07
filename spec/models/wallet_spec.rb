# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'model logic' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'should not exist without a user association' do
      wallet = Wallet.new()
      expect(wallet.save).to be_falsy
    end

    # SMELL change values in sections below to something less static

    it 'should have a currency and minimum balance by default' do
      wallet = Wallet.new(user_id: user1.id)
      expect(wallet.save).to be_truthy
      wallet.reload
      expect(wallet.balance).to eq(1000)
      expect(wallet.currency).to eq('eur')
    end

    it 'should accept other currencies' do
      wallet = Wallet.new(user_id: user1.id, currency: 'test', balance: 10_000)
      expect(wallet.save).to be_truthy
      expect(wallet.balance).to eq(10_000)
      expect(wallet.currency).to eq('test')
    end

    context 'on creation' do
      it 'should accept initial balance above 1000 euros' do
        wallet = Wallet.new(user_id: user1.id, balance: 1100)
        expect(wallet.save).to be_truthy
      end

      it 'should accept initial balance equal to 1000 euros' do
        wallet = Wallet.new(user_id: user1.id, balance: 1100)
        expect(wallet.save).to be_truthy
      end

      it 'should not accept initial balance below 1000 euros' do
        wallet = Wallet.new(user_id: user1.id, balance: 999)
        expect(wallet.save).to be_falsy
      end

      describe 'for currencies other than euro' do
        it 'should accept initial balance above, or equal to, 1000 euros' do
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(1000)

          wallet = Wallet.new(user_id: user1.id, balance: 10)
          expect(wallet.save).to be_truthy
        end

        it 'should not accept initial balance below 1000 euros, for different currencies' do
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(999)

          wallet = Wallet.new(user_id: user1.id, balance: 10)
          expect(wallet.save).to be_falsy
        end
      end
    end

    context 'on save' do
      it 'should accept balances between -100.000 and 1.000.000' do
        wallet = Wallet.new(user_id: user1.id)
        expect(wallet.save).to be_truthy

        wallet.balance = -100_000
        expect(wallet.save).to be_truthy

        wallet.balance = 1_000_000
        expect(wallet.save).to be_truthy
      end

      it 'should not accept balances below -100.000' do
        wallet = Wallet.new(user_id: user1.id, balance: -100_001)
        expect(wallet.save).to be_falsy
      end

      it 'should not accept balances above 1.000.000' do
        wallet = Wallet.new(user_id: user1.id, balance: 1_000_001)
        expect(wallet.save).to be_falsy
      end

      describe 'for currencies other than euro' do
        it 'should accept balances between -100.000 and 1.000.000' do
          wallet = Wallet.new(user_id: user1.id)
          wallet.save

          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(-100_000)
          wallet.balance = -10
          expect(wallet.save).to be_truthy

          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(1_000_000)
          wallet.balance = 100
          expect(wallet.save).to be_truthy
        end

        it 'should not accept balances below -100.000' do
          wallet = Wallet.new(user_id: user1.id)
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(-100_001)
          expect(wallet.save).to be_falsy
        end

        it 'should not accept balances above 1.000.000' do
          wallet = Wallet.new(user_id: user1.id)
          allow_any_instance_of(Wallet).to receive(:convert_to_euro).and_return(1_000_001)
          expect(wallet.save).to be_falsy
        end
      end
    end

    context 'on discard' do
      let(:wallet) { create(:wallet) }

      before(:each) do
        wallet.discard
      end

      it 'discards the instance' do
        expect(wallet.discarded?).to be(true)
        expect(wallet.discarded_at).to be_truthy
        expect(Wallet.kept).to eq([])
      end
    end
  end
end
