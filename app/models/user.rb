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
end
