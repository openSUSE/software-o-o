class MainController < ApplicationController
  before_action :set_distribution, only: :search

  def index; end

  def search
    @packages = @distribution.packages.where('name ILIKE ?', "%#{params[:q]}%").order('LENGTH(name) ASC').order(:weight)
  end
end
