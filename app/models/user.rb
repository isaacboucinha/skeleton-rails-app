# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  name            :text             not null
#  password_digest :string
#  discarded_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  include Discard::Model

  has_many :user_accounts, -> { where('users_accounts.discarded_at IS NULL') }
  has_many :accounts, through: :user_accounts
  has_many :wallets, -> { where('wallets.discarded_at IS NULL') }

  has_secure_password

  validates :name, presence: true, uniqueness: true

  before_validation(on: :create) do
    self.name = Digest::MD5.hexdigest(name) if name
  end
end
