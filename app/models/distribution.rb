# frozen_string_literal: true

# A Linux Distribution
class Distribution < ApplicationRecord
  has_many :repositories, dependent: :destroy
  has_many :packages, through: :repositories
  has_many :categories, -> { distinct }, through: :packages

  validates :name, :obs_repo_names, presence: true

  def sync
    repositories.where(updateinfo: false).find_each(&:sync)
    repositories.where(updateinfo: true).find_each(&:sync)
  end
end
