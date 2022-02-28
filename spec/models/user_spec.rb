# frozen_string_literal: true

# -*- SkipSchemaAnnotations

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'model logic' do
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
      user = User.create(name: 'test', password: 'test')
      user.reload
      expect(user.name).to eq(Digest::MD5.hexdigest('test'))
    end

    it 'should encrypt password' do
      user = User.create(name: 'test', password: 'test')
      expect(user.password_digest).not_to eq('test')
      expect(user.authenticate('test')).to be_truthy
    end

    it 'should not allow users with same name' do
      User.create(name: 'test', password: 'test')
      another_user = User.new(name: 'test', password: 'another_test_password')
      expect(another_user.save).to be_falsy
    end

    it 'should allow users with same password, stored as different digests' do
      user = User.create(name: 'test', password: 'test')
      another_user = User.new(name: 'another_test_password', password: 'test')
      expect(another_user.save!).to be_truthy

      user.reload
      another_user.reload

      expect(user.password_digest).not_to eq(another_user.password_digest)
    end
  end
end
