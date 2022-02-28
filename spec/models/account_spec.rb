# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'model logic' do
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
      account = Account.new(name: 'Test')
      expect(account.save).to be_falsy
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
end
