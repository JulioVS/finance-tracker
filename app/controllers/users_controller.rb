class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    @friend = User.find_by(first_name: params[:friend])

    if @friend
      render json: @friend 
    else     
      render json: params[:friend] 
    end  
  end
  
end