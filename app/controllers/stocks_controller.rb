class StocksController < ApplicationController
  def search
    # L262: Ahora 'new_lookup()' me va a devolver un objeto de clase "Stock" ya formado y cargado,
    #       pero aun sin guardar en la BD (es decir aun con ID y timestamps nulos)
    @stock = Stock.new_lookup(params[:stock])

    # En vez de dejar que se invoque el view correspondiente (que en este caso sería 
    # "views/stocks/search.html.erb"), lo mando "crudo" al browser en formato JSON.-
    # render json: @stock
    
    # L262: Ahora en vez mandarlo crudo en JSON, lo que hago es recargar la pagina de la que vengo
    #       ("my_portfolio") mandandole el objeto Stock en la variable @stock para que la propia
    #       vista lo renderée en una seccion que agregamos debajo de input donde se ingreso el ticker
    #       originalmente.-
    render  'users/my_portfolio'
  end
end