# Helper for distribution controller
module DistributionHelper
  def leap_image_tag(opts = {})
    return image_tag('distributions/testing-white.svg', opts) if action_name == 'testing'
    image_tag('distributions/leap-white.svg', opts)
  end

  def markdownify(text)
    options = { filter_html: true }

    extensions = { autolink: true }

    render = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(render, extensions)

    markdown.render(text).html_safe
  end
end
