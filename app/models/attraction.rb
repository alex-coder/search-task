class Attraction < ApplicationRecord
  has_and_belongs_to_many :activities
  belongs_to :city

  validates :title, presence: true
  validates :description, presence: true
end
