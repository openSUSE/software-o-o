# frozen_string_literal: true

# A Linux Distribution
class Distribution < ApplicationRecord
  has_many :repositories
  has_many :packages, through: :repositories

  validates :name, :obs_repo_names, presence: true
  validates :name, uniqueness: true

  def sync
    repositories.where(updateinfo: false).find_each(&:sync)
    repositories.where(updateinfo: true).find_each(&:sync)
  end
end
