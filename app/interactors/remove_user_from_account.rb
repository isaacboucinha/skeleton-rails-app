# frozen_string_literal: true

class RemoveUserFromAccount
  include Interactor

  before do
    context.fail!(error: 'User should be of type User') unless context.user.is_a?(User)
    context.fail!(error: 'Account should be of type Account') unless context.account.is_a?(Account)
  end

  before do
    context.wallet = nil
  end

  def call
    unless User.find_by_id(context.user.id)
      context.fail!(error: 'The specified user does not exist')
      return
    end
    unless Account.find_by_id(context.account.id)
      context.fail!(error: 'The specified account does not exist')
      return
    end

    context.wallet = Wallet.find_by(user_id: context.user.id, account_id: context.account.id)
    unless context.wallet&.active
      context.fail!(error: 'User account association does not exist')
      return
    end

    context.wallet.active = false
    context.wallet.save!
  end
end
