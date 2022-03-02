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
FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Test#{n}" }
  end
end
