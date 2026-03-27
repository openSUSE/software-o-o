# frozen_string_literal: true

class Patch < ApplicationRecord
  belongs_to :package
  has_many :issues, dependent: :destroy
  enum :status, { stable: 0, retracted: 1 }

  validates :name, uniqueness: { scope: :package }
end
