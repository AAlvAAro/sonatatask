# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :grid_fs

  def store_dir
    "uploads/images/#{model.id}"
  end

  def filename
    @name ||= "#{model.id}.jpg" if original_filename
  end

end
