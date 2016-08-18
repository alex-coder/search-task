class WelcomeController < ApplicationController
  def index
  end

  def search
    search_query = params[:q].downcase
    return redirect_to action: :index if search_query.empty?

    @items = Activity
                .search(
                  query: { match: { title: search_query }}
                )
                .records
                .page(params[:page])
  end
end
