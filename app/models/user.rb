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

  def self.search(entry)
    # Aqui utilizamos el metodo de clase "User.where(...)" simplemente como "where()", pues al 
    # estar aqui en el Users Controller, la clase "User" está implícita.-
    #
    # A su vez, anteponemos "self" en la declaracion de la funcion para que nuestro metodo "search()" 
    # tambien sea un metodo de clase (es decir utilitario) y se pueda invocar desde cualquier lugar
    # de la app como "User.search(...)"
    #
    # Funcionamiento:
    #
    # Hago las tres queries a la BD (por nombre, apellido y mail) utilzando like por lo cual pueden venir
    # multiples resultados en cada una, y a su vez estar duplicados, por ejemplo se busca un nombre que
    # es el apellido de alguien y a su vez es parte de su direccion de correo electronico.-
    #
    # Para ello, concateno las tres busquedas y al resultado le aplico el metodo "uniq" de Rails para 
    # eliminar duplicados del mismo.-
    #
    entry.strip!  # Elimina espacios alrededor del string de busqueda

    matches = ( 
      where( "first_name like ?", "%#{entry}%" ) +
      where( "last_name  like ?", "%#{entry}%" ) +
      where( "email      like ?", "%#{entry}%" )
    ).uniq
  end

end
