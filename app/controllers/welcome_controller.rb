class WelcomeController < ApplicationController
  def index
  end

  def search
    search_query = params[:q].downcase
    return redirect_to action: :index if search_query.empty?

    @items = Activity
                .joins(:tags, :attractions)
                .where('LOWER(activities.title) like ? or
                        LOWER(activities.description) like ? or
                        LOWER(tags.name) like ? or
                        LOWER(attractions.title) like ?',
                    "%#{search_query}%",
                    "%#{search_query}%",
                    "%#{search_query}%",
                    "%#{search_query}%"
                )
                .distinct
                .page(params[:page])
  end
end
