class Task
  include Mongoid::Document
  # include Mongoid::Elasticsearch
  # elasticsearch!

  field :finished, type: Mongoid::Boolean, default: false
  field :expiration, type: Time
  field :content, type: String
  field :tags, type: Array, default: []

  embedded_in :user

  validates :content, presence: true
end
