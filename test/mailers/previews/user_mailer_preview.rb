class UserMailerPreview < ActionMailer::Preview
  def account_activation
    user = User.last
    user.activation_token = User.new_token
    UserMailer.account_activation user
  end
end
