class Task
  include Mongoid::Document
  include Mongoid::Elasticsearch
  include Mongoid::Timestamps
  elasticsearch!

  field :finished, type: Mongoid::Boolean, default: false
  field :expiration, type: Time
  field :content, type: String
  field :tags, type: Array, default: []

  embedded_in :user
  embeds_many :images, cascade_callbacks: true

  validates :content, presence: true

  # Elasticsearch fields to lookup
  def as_indexed_json
    {
      content: content
    }
  end
end
