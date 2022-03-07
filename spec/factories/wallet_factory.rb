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
FactoryBot.define do
  factory :wallet do
    user
  end
end
