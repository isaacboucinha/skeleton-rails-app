# frozen_string_literal: true

class UserAccount < ApplicationRecord
  include Discard::Model

  self.table_name = 'users_accounts'

  belongs_to :user
  belongs_to :account

  # model level validation, so that save() for a repeated user-account association
  # fails gracefully, instead of throwing ActiveRecord::RecordNotUnique
  validates :user_id, uniqueness: { scope: :account_id }
end
