class Image
  include Mongoid::Document

  field :name, type: Stringa
  
  mount_uploader :image, ImageUploader, mount_on: :image_filename

  validates :image, file_size: { maximum: 5.megabytes.to_i }, allow_blank: false

  embedded_in :task
end
