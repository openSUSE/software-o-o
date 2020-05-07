# frozen_string_literal: true

# Provides API for usage in the distros
class ApiController < OBSController
  # Provides info on all the versions of the distributions.
  # GET /api/v0/distributions
  def distributions
    @leap_versions = load_releases
    @tumbleweed_versions = load_snapshots
  end
end
