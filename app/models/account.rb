# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id         :uuid             not null, primary key
#  name       :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Account < ApplicationRecord
  has_many :user_accounts, dependent: :destroy
  has_many :users, through: :user_accounts

  NAME_REGEX = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/
  private_constant :NAME_REGEX

  validates :name, format: { with: NAME_REGEX }, presence: true, uniqueness: true, length: { minimum: 5, maximum: 15 }
end
