class Attraction < ApplicationRecord
  has_and_belongs_to_many :activity
end
