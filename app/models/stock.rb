class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks 

  validates :name, :ticker, presence: true 

  # Version 'fake' del metodo 'new_lookup', sin el servicio IEX CLoud.
  # Simplemente reciclo los stocks que llegué a obtener y cargar en la BD.-
  #
  def self.new_lookup(ticker_symbol) 
    find_by(ticker: ticker_symbol)   
  end

  # Version real del metodo 'new_lookup'. 
  # Como se me vencio el trial de IEX Cloud, no lo puedo seguir usando.- 
  #
  def self.new_lookup_IEX_SERVICE_(ticker_symbol) 
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

    # Antes de invocar la API, inicio un bloque "begin/rescue" para el caso en que el usuario
    # haya ingresado un 'ticker' invalido y la API me devuelva una excepción, en cuyo caso
    # la interceptamos y simplemente devolvemos 'nil' como resultado de la función.-
    #
    begin 
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
    rescue => exception
      # En caso de que la llamada a "quote()" haya devuelto error, aqui interceptamos la excepción para
      # que no se propague hacia arriba y simplemente devolvemos 'nil' como resultado final
      #
      return nil
    end
  end

  # Metodo de clase para verificar si un Ticker ya existe en la DB de Stocks, o no
  def self.check_db(ticker_symbol)
    # Equivale a "Stock.where()" porque al estar justo aqui en la clase Stock, queda implícita
    where(ticker: ticker_symbol).first
  end
end
