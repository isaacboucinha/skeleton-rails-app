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
end
