class Attraction < ApplicationRecord
  has_and_belongs_to_many :activities
  belongs_to :city
end
