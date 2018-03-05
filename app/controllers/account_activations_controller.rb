class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email].downcase
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "account_activations.edit.activated"
      redirect_to user
    else
      flash[:danger] = t "account_activations.edit.invalid_link"
      redirect_to root_url
    end
  end
end
