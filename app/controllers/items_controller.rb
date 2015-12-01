class ItemsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :toggle]
  before_action :set_item, only: [:show]
  before_action :set_user_item, only: [:edit, :update, :toggle]

  def index
    order = params[:newest] ? {created_at: :desc} : {rank: :desc}

    @items = Item.order(order).includes(:user)
    # @votes = @items.includes(:votes).each_with_object({}) do |item, object|
      # object[item.id] = item.votes.map(&:user_id)
    # end
  end

  def show
    @comments = @item.comments.includes(:user).order(created_at: :asc)
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def toggle
    @item.update(:disabled, @item.disabled?)
    message = item.disabled? ? 'disabled' : 'enabled'
    redirect_to @item, notice: "Item #{message}."
  end

  def upvote
    @item = Item.find(params[:id])
    @item.upvote_by current_user
    # @item.update_attribute(:upvotes_count,@item.get_upvotes.size)
    # @item.update_attribute(:downvotes_count,@item.get_downvotes.size)
    # @item.update_attribute(:score,@item.score)
    redirect_to :back
  end

  def downvote
    @item = Item.find(params[:id])
    @item.downvote_by current_user
    # @item.update_attribute(:upvotes_count,@item.get_upvotes.size)
    # @item.update_attribute(:downvotes_count,@item.get_downvotes.size)
    # @item.update_attribute(:score,@item.score)
    redirect_to :back
  end

  private
  def set_item
    @item = Item.find(params[:id])
    # @item = Item.includes(:votes).find(params[:id])
    # @votes = [@item].each_with_object({}) do |item, object|
    #   object[item.id] = item.votes.map(&:user_id)
    # end
  end

  def set_user_item
    @item = current_user.items.where(id: params[:id]).first
    unless @item
      redirect_to :back, notice: 'Unauthorized'
      return
    end
  end

  def item_params
    params.require(:item).permit(:title, :url, :content, :category_id)
  end
end


