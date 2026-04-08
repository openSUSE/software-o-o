# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_distribution
  before_action :set_category, only: %i[show]

  def show; end

  private

  def set_category
    @category = @distribution.categories.find_by!(name: params[:name])
  end
end
