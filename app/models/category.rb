class Category < ApplicationRecord
  has_and_belongs_to_many :packages
  validates :name, presence: true
end
