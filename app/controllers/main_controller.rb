# frozen_string_literal: true

class MainController < ApplicationController
  MAIN_CATEGORIES = %w[Game Development Education Science Multimedia Graphics Office Network Settings Utility].freeze

  def index
    # FIXME: This should be the distro we want to show by default, not the first...
    @distribution = Distribution.first
    @packages = Package.joins(:screenshots_blobs).where(repository: @distribution.repositories).last(4)
    @categories = @distribution.categories.where(name: MAIN_CATEGORIES)
  end
end
