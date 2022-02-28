# frozen_string_literal: true

class CreateAccount
  include Interactor

  before do
    context.fail!(error: 'Name should be a string') unless context.name.is_a?(String)
  end

  before do
    context.account = nil
  end

  def call
    context.account = Account.create!(name: context.name)
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e)
  end
end
