class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :city, :cities

  DEFAULT_CITY_ID = 1

  def detect_city
    city_id = session[:city_id] || DEFAULT_CITY_ID
    City.find(city_id)
  end

  def city
    @city||= detect_city
  end

  def cities
    City.order('name')
  end

  def change_city
    session[:city_id] = params[:id] || DEFAULT_CITY_ID
    redirect_to root_path
  end
end
