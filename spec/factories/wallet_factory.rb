# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    account
    user
  end
end
