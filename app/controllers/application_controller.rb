class ApplicationController < ActionController::Base
  def set_distribution
    @distribution = Distribution.find_by!(name: params[:distribution_name] || params[:distribution])
  end
end
