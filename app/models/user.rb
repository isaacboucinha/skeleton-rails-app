# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  name            :text
#  password_digest :string
#  discarded_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  include Discard::Model

  has_many :wallets, -> { where('wallets.discarded_at IS NULL') }
  has_many :accounts, through: :wallets

  has_secure_password

  validates :name, presence: true, uniqueness: true

  before_validation :hash_name

  private

  def hash_name
    self.name = Digest::MD5.hexdigest(name) if name
  end
end
