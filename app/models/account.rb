# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  name         :string
#  discarded_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Account < ApplicationRecord
  include Discard::Model

  has_many :wallets, -> { where('wallets.discarded_at IS NULL') }
  has_many :users, through: :wallets

  validates :name, presence: true, length: { minimum: 5, maximum: 15 }
  validate :name_is_unique, :name_contains_letters_and_numbers

  private

  def name_is_unique
    return if Account.where('lower(name) = ?', name&.downcase).first.nil?

    errors.add(:name, 'name has to be unique')
  end

  def name_contains_letters_and_numbers
    # matched if name contains:
    # - lower case letters (?=.*[a-z])
    # - upper case letters (?=.*[A-Z])
    # - digits (?=.*\d)
    return if name =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/

    errors.add(:name, 'name must contain lower and upper case letters, and digits')
  end
end
