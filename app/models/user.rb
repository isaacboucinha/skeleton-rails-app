# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  name            :text
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  acts_as_paranoid

  has_many :wallets
  has_many :accounts, through: :wallets

  has_secure_password

  validates :name, presence: true, uniqueness: true

  before_validation :hash_name

  def hash_name
    self.name = Digest::MD5.hexdigest(name) if name
  end
end
