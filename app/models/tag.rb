class Tag < ApplicationRecord
  has_and_belongs_to_many :activities

  validates :name, presence: true
  validates :description, presence: true
end
