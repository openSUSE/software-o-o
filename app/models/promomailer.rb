class Promomailer < ActionMailer::Base
  def promo_order(order)
    recipients  ["abauer@suse.de", "mlasars@suse.de"]
    from        "admin@opensuse.org"
    subject     "openSUSE 11.0 PromoDVD ordertool"
    body        :order => order
  end
end
