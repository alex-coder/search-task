class ActivitiesController < ApplicationController
  def show
    @item = Activity.find(params[:id])
  end

  def index
    @items = Activity.page(params[:page])
  end

  def new
    @item = Activity.new
  end

  def create
    @item = Activity.new(attributes)

    return render action: :new unless @item.valid?

    @item.save!
    redirect_to @item
  end

  def edit
    @item = Activity.find(params[:id])
  end

  def update
    @item = Activity.find(params[:id])

    @item.assign_attributes(attributes)
    return render action: :edit unless @item.valid?

    @item.save!
    redirect_to @item
  end

  private
  def attributes
    params.require(:activity).permit(:title, :description, :city_id, :tag_ids => [])
  end
end
