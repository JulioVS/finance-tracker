class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol) 
    # Recupero las credenciales de mi servicio IEX Cloud desde el YAML de credenciales
    # del proyecto Rails (donde las tengo almacenadas de forma segura bajo el item "iex_client").-
    # Me devuelve un hash con los tokens publico y privado y el link de endpoint que luego
    # uso para establecer la conexion al servicio.-
    #
    iex_client = Rails.application.credentials.iex_client

    # Establezco la conexión con la API de IEX Cloud usando mis credenciales.-
    #
    client = IEX::Api::Client.new(
      publishable_token:  iex_client[:publishable_token],
      secret_token:       iex_client[:secret_token],
      endpoint:           iex_client[:endpoint]
    )

    # Obtengo el precio actual de stock del simbolo (empresa) recibido.-
    # client.price(ticker_symbol)

    # Creo una nueva instancia de la clase "Stock" para que el metodo ya devuelva un objeto
    # armado con los datos necesarios (definidos previamente en el modelo y la db, que serian 
    # "ticker", "nombre" y "precio")
    #
    # Para ello en vez de usar el metodo "price()" de la API de IEX, uso "quote()" que me
    # trae todos los datos de una.-
    #
    quote = client.quote(ticker_symbol)

    # Ahora creo el objeto de la clase Stock (es decir, en la que estamos aqui mismo, por eso 
    # no hace falta hacer "Stock.new()" sino solo "new()") pasandole los datos que me devolvio
    # la API de IEX
    #
    new(
      ticker:       quote.symbol, 
      name:         quote.company_name, 
      last_price:   quote.latest_price
    )

    # debugger
  end

end
