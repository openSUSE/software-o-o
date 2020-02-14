# frozen_string_literal: true

class ApiController < OBSController
  # Provides info on all the versions of the distributions.
  # GET /api/v0/distributions
  def distributions
    @leap_versions = load_releases
  end
end
