class Promomailer < ActionMailer::Base
  def promo_order(order)
    # TODO: move to config/environment.rb
    recipients  ["promodvds@opensuse.org"]
    from        order[:email]
    subject     "openSUSE PromoDVD order: #{order[:amount]} to #{order[:name]}"
    body        :order => order
  end
end
