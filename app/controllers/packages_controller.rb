class PackagesController < ApplicationController
  before_action :set_distribution
  before_action :set_package, only: %i[show update]

  def show; end

  private

  def set_package
    @package = @distribution.packages.find_by!(name: params[:name])
  end
end
