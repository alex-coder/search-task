class TagsController < ApplicationController
  def show
    @item = Tag.find(params[:id])
  end

  def index
    @items = Tag.all
  end
end
