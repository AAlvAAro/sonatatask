class Image
  include Mongoid::Document

  field :name, type: String
  
  mount_uploader :image, ImageUploader, mount_on: :image_filename

  embedded_in :task
end
