class ActivitiesController < ApplicationController
  def show
    @item = Activity.find(params[:id])
  end
end
