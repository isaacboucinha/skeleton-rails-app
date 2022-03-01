# frozen_string_literal: true

# == Schema Information
#
# Table name: wallets
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  account_id :uuid             not null
#  balance    :decimal(, )
#  currency   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :account

  # model level validation, so that save() for a repeated user-account association
  # fails gracefully, instead of throwing ActiveRecord::RecordNotUnique
  validates :user_id, uniqueness: { scope: :account_id }

  validate :minimum_amount_for_creation, on: :create
  validate :ensure_min_and_max_balance

  # SMELL change values in sections below to something less static

  def ensure_min_and_max_balance
    euros = convert_to_euro
    if euros >= -100_000
      errors.add(:balance, 'balance can not exceed 1.000.000 euros (exchange rate may vary)') unless euros <= 1_000_000
    else
      errors.add(:balance, 'balance should be at more than negative 100.000 euros (exchange rate may vary)')
    end
  end

  def minimum_amount_for_creation
    return if convert_to_euro >= 1000

    errors.add(:balance, 'balance should be at least 1000 euros (exchange rate might vary)')
  end

  # DUMMY we'll assume all other currencies have a 90% exchange rate to euros
  def convert_to_euro
    return balance if currency.eql?('eur')

    balance / 10
  end
end
