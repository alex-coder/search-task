class ActivitiesController < ApplicationController
  def show
    @item = Activity.find(params[:id])
  end

  def index
    @items = Activity.page(params[:page])
  end
end
