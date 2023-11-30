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
    client.price(ticker_symbol)
  end

end
