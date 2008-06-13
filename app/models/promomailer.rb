class Promomailer < ActionMailer::Base
  def promo_order(order)
    recipients  ["abauer@suse.de"]
    from        "admin@opensuse.org"
    subject     "openSUSE 11.0 PromoDVD order"
    body        :order => order
  end
end
