class OrderController < ApplicationController
  session :disabled => false

  def new
    @order = Order.new params[:order]
  end

  def save
    @order = Order.new params[:order]
    if @order.save
      Promomailer.deliver_promo_order @order
      redirect_to :action => "thanks"
    else
      flash[:save_errors] = @order.errors.full_messages
      redirect_to :action => "new", :order => params[:order]
    end
  end

  def thanks
  end
end
