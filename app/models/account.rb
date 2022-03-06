# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  name         :citext           not null
#  discarded_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Account < ApplicationRecord
  include Discard::Model

  has_many :wallets, -> { where('wallets.discarded_at IS NULL') }
  has_many :users, through: :wallets

  NAME_REGEX = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/
  private_constant :NAME_REGEX

  validates :name, format: { with: NAME_REGEX }, presence: true, uniqueness: true, length: { minimum: 5, maximum: 15 }
end
