class StocksController < ApplicationController

  def search

    if params[:stock].present?
      # Ingresó un ticker en la pagina - busco el stock
      @stock = Stock.new_lookup(params[:stock])

      if @stock
        # El ticker era valido y el metodo devolvio un objeto "Stock"
        respond_to do | format |
          format.js { render partial: 'users/result_js' } 
        end
      else
        # El ticker no era valido y el metodo devolvio "null"
        respond_to do | format |
          flash.now[:alert] = "Invalid symbol. Please enter a valid symbol to search"
          format.js { render partial: 'users/result_js' }
        end
      end

    else
      # No ingresó nada en la pagina
      respond_to do | format |
        flash.now[:alert] = "Please enter a symbol to search"
        format.js { render partial: 'users/result_js' }
      end
    end

  end

end