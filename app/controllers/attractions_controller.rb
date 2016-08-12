class AttractionsController < ApplicationController
  def show
    @item = Attraction.find(params[:id])
  end

  def index
    @items = Attraction.page(params[:page])
  end
end
