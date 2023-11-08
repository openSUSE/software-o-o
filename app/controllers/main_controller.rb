# frozen_string_literal: true

class MainController < ApplicationController
  def index
    # FIXME: This should be the distro we want to show by default, not the first...
    @distribution = Distribution.first
  end
end
