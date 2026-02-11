# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :set_distribution

  def index
    @packages = @distribution.packages.where('name ILIKE ?', "%#{params[:q]}%").order('LENGTH(name) ASC').order(:weight)
  end
end
