class Activity < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :city
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :attractions

  validates :title, presence: true
  validates :description, presence: true

  after_touch() { __elasticsearch__.index_document }

  settings index: { number_of_shards: 1, number_of_replicas: 0, include_in_parent: true } do
    mappings do
      indexes :title, analyzer: 'russian'
      indexes :description, analyzer: 'russian'
      indexes :city, type: 'nested' do
        indexes :name, analyzer: 'russian'
      end

      indexes :tags, type: 'nested' do
        indexes :name, analyzer: 'russian'
      end

      indexes :attractions, type: 'nested' do
        indexes :name, analyzer: 'russian'
        indexes :description, analyzer: 'russian'
      end
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
