# frozen_string_literal: true

# A Linux Distribution
class Distribution < ApplicationRecord
  has_many :repositories
  has_many :packages, through: :repositories

  validates :name, :obs_repo_names, presence: true

  def sync
    repositories.where(updateinfo: false).each(&:sync)
    repositories.where(updateinfo: true).each(&:sync)
  end
end
