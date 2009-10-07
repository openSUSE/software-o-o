class Promomailer < ActionMailer::Base
  def promo_order(order)
    # TODO: move to config/environment.rb
    recipients  ["jbrockmeier@novell.com", "michl@suse.de"]
    from        "admin@opensuse.org"
    subject     "openSUSE 11.0 PromoDVD ordertool"
    body        :order => order
  end
end
