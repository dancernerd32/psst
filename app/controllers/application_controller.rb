class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
        :first_name,
        :last_name,
        :username,
        :email,
        :password,
        :password_confirmation,
        :remember_me,
        :secret_key_p,
        :secret_key_q,
        :public_key_m,
        :public_key_k
      )
    end

    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(
        :login,
        :username,
        :email,
        :password,
        :remember_me
      )
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :current_password
      )
    end
  end
end
