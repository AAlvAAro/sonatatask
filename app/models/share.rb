class Share < Task
  include Mongoid::Document

  field :share_id, type: BSON::ObjectId
  field :owner_id, type: BSON::ObjectId
  field :friend_id, type: BSON::ObjectId

  embedded_in :user
end
