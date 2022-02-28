# frozen_string_literal: true

class DeleteUser
  include Interactor

  before do
    context.fail!(error: 'Name should be a string') unless context.name.is_a?(String)
  end

  def call
    user = User.find_by(name: context.name)
    if user
      user.destroy
    else
      context.fail!(error: 'Record not found')
    end
  end
end
