class StocksController < ApplicationController

  def search

    # If a ticker was sent, search for the stock
    if params[:stock].present?

      @stock = Stock.new_lookup(params[:stock])

      # If it was an invalid ticker...
      if !@stock
        flash.now[:alert] = "Invalid entry. Please enter a valid symbol to search"
      end
    else
        flash.now[:alert] = "Please enter a symbol to search"
    end

    # AJAX Response - Renders the partial in both success and error scenarios
    #                 sending either a valid Stock or an error message 
    respond_to do | format |
      format.js { render partial: 'users/result_js' }
    end
  end

end