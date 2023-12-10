class FriendshipsController < ApplicationController
  before_action :set_friend

  def create
    current_user.friends.append(@friend)

    flash[:notice] = "Now following #{@friend.full_name}"
    redirect_to my_friends_path
  end

  def destroy
    current_user.friends.delete(@friend)
  
    flash[:notice] = "Stopped following #{@friend.full_name}"
    redirect_to my_friends_path
  end

  private

  def set_friend
    @friend = User.find(params[:id])
  end
end