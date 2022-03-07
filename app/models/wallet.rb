# frozen_string_literal: true

# == Schema Information
#
# Table name: wallets
#
#  id           :uuid             not null, primary key
#  user_id      :uuid             not null
#  balance      :integer          default(100000)
#  currency     :string           default("eur")
#  discarded_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Wallet < ApplicationRecord
  include Discard::Model

  belongs_to :user

  validate :minimum_amount_for_creation, on: :create
  validate :ensure_min_and_max_balance

  private

  def ensure_min_and_max_balance
    euros = convert_to_euro
    if euros >= Globals::Amounts::MINIMUM_BALANCE_FOR_WALLET
      unless euros <= Globals::Amounts::MAXIMUM_BALANCE_FOR_WALLET
        errors.add(:balance,
                   "balance can not exceed #{Globals::Amounts::MAXIMUM_BALANCE_FOR_WALLET} euros "\
                   '(exchange rate may vary)')
      end
    else
      errors.add(:balance,
                 "balance should be at more than #{Globals::Amounts::MINIMUM_BALANCE_FOR_WALLET} euros "\
                 '(exchange rate may vary)')
    end
  end

  def minimum_amount_for_creation
    return if convert_to_euro >= Globals::Amounts::MINIMUM_FOR_WALLET_CREATION

    errors.add(:balance,
               "balance should be at least #{Globals::Amounts::MINIMUM_FOR_WALLET_CREATION} euros "\
               '(exchange rate might vary)')
  end

  # DUMMY we'll assume all other currencies have a 90% exchange rate to euros
  def convert_to_euro
    return balance if currency.eql?('eur')

    balance / 10
  end
end
