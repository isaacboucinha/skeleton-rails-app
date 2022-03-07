# frozen_string_literal: true

class AddUserToAccount
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

    unless context.user&.persisted?
      context.fail!(error: 'The specified user does not exist')
      return
    end
    unless context.account&.persisted?
      context.fail!(error: 'The specified account does not exist')
      return
    end
  end

  before do
    context.user_account = nil
  end

  def call
    context.user_account = UserAccount.all.find_by(user_id: context.user.id, account_id: context.account.id)
    if context.user_account
      if context.user_account.discarded?
        context.user_account.undiscard
      else
        context.fail!(error: 'User account association already exists')
      end
      return
    end

    context.user_account = UserAccount.create!(user_id: context.user.id, account_id: context.account.id)
  end
end
