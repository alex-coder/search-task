class Activity < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :city
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :attractions

  validates :title, presence: true
  validates :description, presence: true

  after_commit on: [:create] do
    __elasticsearch__.index_document
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document
  end

  # after_commit on: [:destroy] do
  #   __elasticsearch__.delete_document
  # end

  settings do
    mappings do
      indexes :title, analyzer: 'russian'
      indexes :description, analyzer: 'russian'
    end
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [ :title, :description ],
      include: {
        city: { only: :name },
        tags: { only: :name },
        attractions: { only: [:name, :description] }
      }
    )
  end
end
