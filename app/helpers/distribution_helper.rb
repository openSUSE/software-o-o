# frozen_string_literal: true

# Helper for distribution controller
module DistributionHelper
  def leap_image_tag(opts = {})
    image_name = @version == @testing_version ? 'testing' : 'leap'
    image_tag("distributions/#{image_name}-white.svg", opts)
  end

  def markdownify(text)
    options = { filter_html: true }

    extensions = { autolink: true }

    render = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(render, extensions)

    markdown.render(text).html_safe
  end
end
