class Task
  include Mongoid::Document
  include Mongoid::Elasticsearch
  elasticsearch!

  field :finished, type: Mongoid::Boolean, default: false
  field :expiration, type: Time
  field :content, type: String
  field :sharer_id, type: String
  field :sharer_username, type: String

  embedded_in :user
  embeds_many :tags, cascade_callbacks: true
  embeds_many :images, cascade_callbacks: true

  validates :content, presence: true
end
