# frozen_string_literal: true

class RemoveUserFromAccount
  include Interactor

  before do
    unless context.user.is_a?(User)
      context.fail!(error: 'User should be of type User')
      return
    end

    unless context.account.is_a?(Account)
      context.fail!(error: 'Account should be of type Account')
      return
    end

    unless context.user.persisted?
      context.fail!(error: 'The specified user does not exist')
      return
    end
    unless context.account.persisted?
      context.fail!(error: 'The specified account does not exist')
      return
    end
  end

  before do
    context.user_account = nil
  end

  def call
    context.user_account = UserAccount.all.find_by(user_id: context.user.id, account_id: context.account.id)
    unless context.user_account
      context.fail!(error: 'User account association does not exist')
      return
    end

    context.success = context.user_account.delete
  end
end
