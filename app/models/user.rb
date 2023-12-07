class User < ApplicationRecord
  # Relacion "n a n" entre usuarios y stocks: 
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Ralacion "n a n" entre usuarios y usuarios "amigos":
  has_many :friendships
  has_many :friends, through: :friendships
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def stock_already_tracked?(ticker_symbol)
    # Primero verifica que el stock a seguir ya exista en la BD.-
    # Si no existe, significa que ningun usuario lo esta siguiendo aun.-
    stock = Stock.check_db(ticker_symbol)
    return false unless stock 

    # Si el stock ya existe en nuestra DB, es que al menos algun usuario lo esta 
    # siguiendo, aunque no necesariamente el actual que lo esta solicitando.-
    # Entones, verifico si el ID del stock en cuestion ya existe en la coleccion
    # de stocks del usuario actual:
    stocks.where(id: stock.id).exists?  # devuelve boolean, que a su vez es el resultado de la funcion
  end

  def under_stock_limit?
    # Pusimos como limite que solo pueda seguir hasta 10 stocks
    stocks.count < 10     # devuelve boolean, que a su vez es el resultado de la funcion
  end
    
  def can_track_stock?(ticker_symbol)
    # Si aun esta bajo el limite de 10 stocks y ya no estaba siguiendo ese ticker: da TRUE
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
end
