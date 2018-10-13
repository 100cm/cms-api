class FileUploader < CarrierWave::Uploader::Base
  storage :file

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end


end
