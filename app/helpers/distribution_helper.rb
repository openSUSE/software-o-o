# Helper for distribution controller
module DistributionHelper
  def leap_image_tag(opts = {})
    return image_tag('distributions/testing.svg', opts) if action_name == 'testing'
    image_tag('distributions/leap.svg', opts)
  end
end
