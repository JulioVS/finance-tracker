class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    entry = params[:friend] 
   
    if entry.present?
      @friend = User.find_by(first_name: entry)
      @friend = User.find_by(last_name: entry) if !@friend 
      @friend = User.find_by(email: entry) if !@friend 
   
      if !@friend
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