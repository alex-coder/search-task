class Activity < ApplicationRecord
  belongs_to :city
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :attractions

  validates :title, presence: true
  validates :description, presence: true
end
