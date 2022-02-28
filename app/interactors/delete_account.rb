# frozen_string_literal: true

class DeleteAccount
  include Interactor

  before do
    context.fail!(error: 'Name should be a string') unless context.name.is_a?(String)
  end

  def call
    account = Account.find_by(name: context.name)
    if account
      account.destroy
    else
      context.fail!(error: 'Record not found')
    end
  end
end
