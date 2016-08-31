class WelcomeController < ApplicationController
  def index
  end

  def search
    search_query = params[:q].downcase
    return redirect_to action: :index if search_query.empty?

    @items = Activity
                .search(
                  query: {
                    multi_match: {
                      query: search_query,
                      fields: %W(title description tags.name categories.name categories.description)
                    }
                  }
                )
                .page(params[:page])
                .records
  end
end
