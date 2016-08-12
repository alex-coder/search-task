class AttractionsController < ApplicationController
  def show
    @item = Attraction.find(params[:id])
  end
end
