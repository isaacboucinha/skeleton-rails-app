# frozen_string_literal: true

class MoveAmountBetweenWallets
  include Interactor

  before do
    unless context.from_wallet.is_a?(Wallet) && context.to_wallet.is_a?(Wallet)
      context.fail!(error: 'Wallets should be of type wallet')
      return
    end

    unless context.amount.is_a?(Numeric)
      context.fail!(error: 'Amount should be a numerical value')
      return
    end

    unless Wallet.find_by_id(context.from_wallet.id)
      context.fail!(error: 'The specified wallet from which to move amount does not exist')
      return
    end

    unless Wallet.find_by_id(context.to_wallet.id)
      context.fail!(error: 'The specified wallet to which to move amount does not exist')
      return
    end
  end

  def call
    Wallet.transaction do
      context.from_wallet.balance -= context.amount
      context.to_wallet.balance += context.amount
      context.from_wallet.save!
      context.to_wallet.save!
    end
  end
end
