# frozen_string_literal: true

class DeleteAccount
  include Interactor

  before do
    context.fail!(error: 'Account should be of type Account') unless context.account.is_a?(Account)
  end

  def call
    context.account.destroy
  rescue ActiveRecord::RecordNotDestroyed => e
    context.fail!(error: e.record.errors)
  end
end
