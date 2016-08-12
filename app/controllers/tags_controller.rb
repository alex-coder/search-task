class TagsController < ApplicationController
  def show
    @item = Tag.find(params[:id])
  end

  def index
    @items = Tag.all
  end

  def new
    @item = Tag.new
  end

  def create
    @item = Tag.new(attributes)

    return render action: :new unless @item.valid?

    @item.save!
    redirect_to @item
  end

  def edit
    @item = Tag.find(params[:id])
  end

  def update
    @item = Tag.find(params[:id])

    @item.assign_attributes(attributes)
    return render action: :edit unless @item.valid?

    @item.save!
    redirect_to @item
  end

  private
  def attributes
    params.require(:tag).permit(:name, :description)
  end
end
