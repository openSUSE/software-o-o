# frozen_string_literal: true

class ApiController < OBSController
  def distributions
    @leap_versions = load_releases
  end
end
