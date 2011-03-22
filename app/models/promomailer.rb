class Promomailer < ActionMailer::Base
  def promo_order(order)
    # TODO: move to config/environment.rb
    recipients  ["promodvds@opensuse.org", "tschmidt@suse.de"]
    from        "admin@opensuse.org"
    subject     "openSUSE PromoDVD order"
    body        :order => order
  end
end
