# frozen_string_literal: true

class SendUserCredentials
  include Interactor

  before do
    context.fail!(error: 'Should pass a User as an argument') unless context.user.is_a?(User)
  end

  def call
    puts 'Sending credentials via email. Check them there!' # if Rails.env.test?
  end
end
