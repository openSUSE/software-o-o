class Promomailer < ActionMailer::Base
  def promo_order(order)
    @order = order
    mail(to: CONFIG['order_mails_to'], from: order[:email], subject: "openSUSE PromoDVD order: #{order[:amount]} to #{order[:name]}")
  end
end
