class Share < Task
  include Mongoid::Document

  field :owner_id, type: BSON::ObjectId
  field :friend_id, type: BSON::ObjectId

  belongs_to :user
end
