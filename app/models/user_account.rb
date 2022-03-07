# frozen_string_literal: true

# == Schema Information
#
# Table name: users_accounts
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  account_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserAccount < ApplicationRecord
  self.table_name = 'users_accounts'

  belongs_to :user
  belongs_to :account

  # model level validation, so that save() for a repeated user-account association
  # fails gracefully, instead of throwing ActiveRecord::RecordNotUnique
  validates :user_id, uniqueness: { scope: :account_id }
end
