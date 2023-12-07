class Friendship < ApplicationRecord
  #
  # Este Model representa una relacion "n a n" de User con si mismo, es decir, un usuario
  # es amigo de otro usuario.-
  #
  # El primero es simplemente un 'user' (que automaticamente remite a la tabla 'users')
  # mientras que al segundo lo llamamos 'friend', pero le avisamos a Rails que no es de otro 
  # modelo llamado "Friend", sino que se trata de otro "User".-
  #
  # De otro modo Rails automaticamente buscaria un modelo 'Friend' y una tabla 'friends', que
  # no existen en nuestra app.-
  #

  # Generado automaticamente por Rails:
  belongs_to :user

  # Agregado por nosotros:
  belongs_to :friend, class_name: 'User'
end
