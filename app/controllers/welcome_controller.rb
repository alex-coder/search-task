class WelcomeController < ApplicationController
  def index
  end

  def search
    search_query = params[:q].downcase
    return redirect_to action: :index if search_query.empty?

    @items = Activity
                .select('activities.*, IF (activities.city_id = 1, 1, 0) as cond')
                .joins(:tags, :attractions, :city)
                .where('LOWER(activities.title) like ? or
                        LOWER(activities.description) like ? or
                        LOWER(tags.name) like ? or
                        LOWER(attractions.title) like ? or
                        LOWER(cities.name) like ?',
                    "%#{search_query}%",
                    "%#{search_query}%",
                    "%#{search_query}%",
                    "%#{search_query}%",
                    "%#{search_query}%"
                )
                .order('cond desc')
                .distinct
                .page(params[:page])
  end
end
