# frozen_string_literal: true

class Category < ApplicationRecord
  has_and_belongs_to_many :packages
  validates :name, presence: true

  def related
    packages.map(&:categories).flatten.uniq
  end

  def icon
    { Game: 'fa-gamepad',
      Development: 'fa-code',
      Education: 'fa-graduation-cap',
      Science: 'fa-microscope',
      Multimedia: 'fa-circle-play',
      Graphics: 'fa-image',
      Office: 'fa-file-lines',
      Network: 'fa-wifi',
      Settings: 'fa-gear',
      Utility: 'fa-screwdriver-wrench' }.with_indifferent_access[name]
  end
end
