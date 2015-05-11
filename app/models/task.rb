class Task
  include Mongoid::Document
  include Mongoid::Elasticsearch
  include Mongoid::Timestamps
  elasticsearch!

  field :finished, type: Mongoid::Boolean, default: false
  field :expiration, type: Time
  field :content, type: String
  field :tags, type: Array, default: []
  field :sharing_id, type: String
  field :shared_with, type: Array
  field :owner_id, type: String

  embedded_in :user
  embeds_many :images, cascade_callbacks: true

  validates :content, presence: true

  before_create :generate_sharing_id

  # Elasticsearch fields to lookup
  def as_indexed_json
    {
      content: content
    }
  end

  protected
    def generate_sharing_id

    end
end
