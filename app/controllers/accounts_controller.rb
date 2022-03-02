# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[show update destroy]

  # GET /accounts
  def index
    @accounts = Account.all

    render json: @accounts
  end

  # GET /accounts/1
  def show
    render json: @account
  end

  # POST /accounts
  def create
    context = CreateAccount.call(account_params)

    if context.success?
      render json: context.account, status: :created, location: context.account
    else
      render json: context.error, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      render json: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  def destroy
    context = DeleteAccount.call(account: @account)

    if context.success?
      head :no_content
    else
      render json: context.error, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:name, :id)
  end
end
