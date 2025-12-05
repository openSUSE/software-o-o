# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def set_distribution
    @distribution = Distribution.find_by!(name: params[:distribution_name] || params[:name])
  end
end
