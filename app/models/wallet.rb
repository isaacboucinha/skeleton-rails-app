# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :users
  belongs_to :accounts
end
