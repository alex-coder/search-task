class WelcomeController < ApplicationController
  def index
  end

  def search
    search_query = params[:q]
    return redirect_to action: :index if search_query.empty?

    @items = Activity.where('title like ? or description like ?', "%#{search_query}%", "%#{search_query}%")

  end
end
