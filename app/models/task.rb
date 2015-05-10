class Task
  include Mongoid::Document
  # include Mongoid::Elasticsearch
  # elasticsearch!

  field :finished, type: Mongoid::Boolean, default: false
  field :expiration, type: Time
  field :content, type: String

  embedded_in :user
  embeds_many :tasks, cascade_callbacks: true

  validates :content, presence: true
end
