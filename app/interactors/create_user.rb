# frozen_string_literal: true

class CreateUser
  include Interactor

  before do
    unless context.name.is_a?(String) && context.password.is_a?(String)
      context.fail!(error: 'Name and password should be a string')
    end
  end

  before do
    context.user = nil
  end

  def call
    context.user = User.create!(name: context.name, password: context.password)
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e)
  end
end
