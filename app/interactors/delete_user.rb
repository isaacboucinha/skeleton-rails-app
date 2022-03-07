# frozen_string_literal: true

class DeleteUser
  include Interactor

  before do
    context.fail!(error: 'User should be of type User') unless context.user.is_a?(User)
  end

  def call
    context.user.destroy
  rescue ActiveRecord::RecordNotDestroyed => e
    context.fail!(error: e.record.errors)
  end
end
