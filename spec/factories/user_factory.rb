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
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:password) { |n| "password#{n}" }
  end
end
