class UserStocksController < ApplicationController

  def create
    # Verifico primero si ya no tengo ese objeto Stock creado en la base de datos
    stock = Stock.check_db(params[:ticker])

    # Si no lo tengo, llamo a la API de IEX Cloud y creo uno (via 'new_lookup')
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    
    # Ya con el objeto Stock obtenido por cualquiera de las vias, creo la relacion
    # entre el usuario logueado (uso helper 'current_user' de Devise) y dicho stock
    @user_stock = UserStock.create(user: current_user, stock: stock)

    flash[:notice] = "Stock #{stock.name} was successfully added to your profile"
    redirect_to my_portfolio_path
  end

  def destroy
    # Find target stock
    stock = Stock.find(params[:id])

    # Delete from current user's stocks collection
    current_user.stocks.delete(stock) 

    flash[:notice] = "#{stock.ticker} was successfully removed from portfolio"
    redirect_to my_portfolio_path
  end

end
