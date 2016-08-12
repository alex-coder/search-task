class AttractionsController < ApplicationController
  def show
    @item = Attraction.find(params[:id])
  end

  def index
    @items = Attraction.page(params[:page])
  end

  def new
    @item = Attraction.new
  end

  def create
    @item = Attraction.new(attributes)

    return render action: :new unless @item.valid?

    @item.save!
    redirect_to @item
  end

  def edit
    @item = Attraction.find(params[:id])
  end

  def update
    @item = Attraction.find(params[:id])

    @item.assign_attributes(attributes)
    return render action: :edit unless @item.valid?

    @item.save!
    redirect_to @item
  end

  private
  def attributes
    params.require(:attraction).permit(:title, :description, :city_id, :activity_ids => [])
  end
end
