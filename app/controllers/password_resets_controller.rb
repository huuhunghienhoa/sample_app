class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.create.sent_email_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.create.not_found_email"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("password_resets.update.empty_password")
      render :edit
    elsif @user.update_attributes user_params
      update_pass_success
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    redirect_to root_url unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "password_resets.check_expiration.expired_password"
      redirect_to new_password_reset_url
    end
  end

  def update_pass_success
    log_in @user
    @user.update_attribute :reset_digest, nil
    flash[:success] = t "password_resets.update.reset_password"
    redirect_to @user
  end
end
