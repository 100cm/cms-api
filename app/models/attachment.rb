class Attachment < ApplicationRecord

  include BaseModelConcern

  mount_uploader :file, FileUploader

  def self.create_by_params(params)
    attachment = nil
    response   = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!

      # 验证必填参数
      must_params = params.require(:create).values

      res.raise_error("缺少参数") if Attachment.validate_blank?(must_params)

      attachment = Attachment.new(create_params)
      attachment.save!
    end
    return response, attachment
  end


  def self.update_by_params(params)
    attachment = nil
    response   = Response.rescue do |res|
      user          = params[:user]
      attachment_id = params[:attachment_id]
      res.raise_error("缺少参数") if attachment_id.blank?
      update_params = params.require(:update).permit!

      attachment = Attachment.find(attachment_id)

      res.raise_data_miss_error("attachment不存在") if attachment.blank?

      attachment.update_attributes!(update_params)
    end
    return response, attachment
  end


  def self.query_by_params(params)
    attachments = nil
    response    = Response.rescue do |res|
      page, per, search_param = params[:page] || 1, params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      attachments             = Attachment.search_by_params(search_param).page(page).per(per)
    end
    return response, attachments
  end

  def self.delete_by_params(params)
    attachment = nil
    response   = Response.rescue do |res|
      attachment_id = params[:attachment_id]
      res.raise_error("参数缺失") if attachment_id.blank?
      attachment = Attachment.find(attachment_id)
      res.raise_data_miss_error("Attachment不存在") if attachment.blank?
      attachment.destroy!
    end
    return response
  end

end

