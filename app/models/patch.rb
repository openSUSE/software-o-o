class Patch < ApplicationRecord
  belongs_to :package
  has_many :issues, dependent: :destroy
  enum :status, [ :stable, :retracted ]

  validates :name, uniqueness: { scope: :package }
end
