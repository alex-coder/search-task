class City < ApplicationRecord
  has_many :activities
  belongs_to :country
end
