class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    if @user
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      not_found
    end
  end

  def destroy
    if @relationship
      @user = @relationship.followed
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      not_found
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
  end

  def not_found
    render(file: "public/404.html", status: 404, layout: true)
  end
end
