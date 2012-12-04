class OrderController < ApplicationController

  respond_to :html, :json

  def list
    #@orders = Order.find :all, :limit => 200, :order => "created_at DESC"
    redirect_to :action => "index"
  end

  def index
    redirect_to :action => "new"
  end

  def show
    redirect_to :action => "new"
  end

  def pause
  end

  def new
    @order = Order.new
    respond_with(@order)
    #redirect_to :action => "pause"
  end
  
  def create
    @order = Order.new params[:order]
    if @order.save
      Promomailer.promo_order(@order).deliver
      redirect_to "/order/thanks" and return
    else
      flash.now[:error] = "Your submission could not be processed, please fix the problems listed below: \n"
      flash.now[:error] += @order.errors.full_messages.join("\n")
      render 'order/new'
    end
  end

end
