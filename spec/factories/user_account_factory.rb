# frozen_string_literal: true

# == Schema Information
#
# Table name: users_accounts
#
#  id           :uuid             not null, primary key
#  user_id      :uuid             not null
#  account_id   :uuid             not null
#  discarded_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :user_account do
    user
    account
  end
end
