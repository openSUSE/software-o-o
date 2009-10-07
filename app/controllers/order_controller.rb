class OrderController < ApplicationController

  before_filter :require_auth, :except => [:new, :save, :thanks]

  def new
    @order = Order.new params[:order]
    render :template => 'order/pause'
  end

  def save
    @order = Order.new params[:order]
    if @order.save
      Promomailer.deliver_promo_order @order
      redirect_to "/order/thanks"
    else
      flash[:save_errors] = @order.errors.full_messages
      redirect_to :action => "new", :order => params[:order]
    end
  end

  def thanks
  end

  # admin stuff
  def require_auth
    auth = request.env['HTTP_AUTHORIZATION'].to_s.split

    if auth and auth[0] == "Basic"
      login, pw = Base64.decode64(auth[1]).split(':')[0..1]
      pw ||= ""
      # TODO: fix this when we enable the online ordering again
      if login == "admin" and pw == "secret" and false
        @user = session[:admin_user]
        return true
      end
    end

    response.headers["WWW-Authenticate"] = 'basic realm="software.opensuse.org admin login"'
    render :text => "authentication required", :status => 401
    return false
  end
  private :require_auth

  def admin_index
    @orders = Order.find :all, :conditions => "isnull(processed_by)"
  end

  def change_name
    session[:admin_user] = params[:name]
    redirect_to :action => :admin_index
  end

  def logout
    session[:admin_user] = nil
    redirect_to :action => :admin_index
  end

  def process_order
    @order = Order.find params[:id]
    @order.processed_at = Time.now
    @order.processed_by = session[:admin_user]

    @order.save
    
    render :partial => 'order', :object => @order
  end
end
