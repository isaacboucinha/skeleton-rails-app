# frozen_string_literal: true

class CreateUserAndSendCredentials
  include Interactor::Organizer

  organize CreateUser, SendUserCredentials
end
