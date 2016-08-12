class TagsController < ApplicationController
  def show
    @item = Tag.find(params[:id])
  end
end
