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

    unless User.find_by_id(context.user.id)
      context.fail!(error: 'The specified user does not exist')
      return
    end
    unless Account.find_by_id(context.account.id)
      context.fail!(error: 'The specified account does not exist')
      return
    end
  end

  before do
    context.wallet = nil
  end

  def call
    context.wallet = Wallet.with_deleted.find_by(user_id: context.user.id, account_id: context.account.id)
    unless context.wallet && !context.wallet.deleted_at
      context.fail!(error: 'User account association does not exist')
      return
    end

    context.wallet.delete
  end
end
