# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  name            :text             not null
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_many :user_accounts, dependent: :destroy
  has_many :accounts, through: :user_accounts
  has_many :wallets, dependent: :destroy

  has_secure_password

  validates :name, presence: true, uniqueness: true

  before_validation(on: :create) do
    self.name = Digest::MD5.hexdigest(name) if name
  end
end
