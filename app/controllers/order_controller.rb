class OrderController < ApplicationController


  def list
    @orders = Order.find :all
  end


  def pause
  end

  def new
    @order = Order.new
    #redirect_to :action => "pause"
  end
  
  def save
    @order = Order.new params[:order]
    if @order.save
      Promomailer.deliver_promo_order @order
      redirect_to "/order/thanks" and return
    else
      flash.now[:error] = "Your submission could not be processed, please fix the problems listed below: \n"
      flash.now[:error] += @order.errors.full_messages.join("\n")
      render 'order/new'
    end
  end

end
