class ApplicationController < ActionController::Base
  before_action :authenticate_user! 

  # Todo esto es para Devise me permita actualizar los campos de nombre y apelllido
  # que agregamos a posteriori en el model User.-
  # Ahora, cuando los modifico en la pagina "/users/edit", Devise me los actualiza
  # en la base de datos.-
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
