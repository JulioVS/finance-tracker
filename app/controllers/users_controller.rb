class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @stocks = @user.stocks
  end

  def my_friends
    @user = current_user
    @friends = @user.friends
  end

  def show
    @user = User.find(params[:id])
    @stocks = @user.stocks
    @friends = @user.friends
  end

  def search
    entry = params[:friend] 
   
    if entry.present?
      @friends = User.search(entry)
      @friends.delete(current_user)  # avoids listing the logged user himself in the search results

      if @friends.empty? 
        flash[:alert] = "Sorry, could not find the user"     
      end
    else
      flash[:alert] = "Please enter a name or email address to search"
    end
   
    respond_to do | format |
      format.js { render partial: 'users/friend_js' }
    end
  end

end