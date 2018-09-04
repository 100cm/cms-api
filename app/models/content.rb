class Content < ApplicationRecord

  include BaseModelConcern

  belongs_to :menu

  mount_uploader :cover, FileUploader

  default_scope { order(created_at: :asc) }

  def self.create_by_params(params)
    content  = nil
    response = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!

      # 验证必填参数
      must_params = params.require(:create).values

      res.raise_error("缺少参数") if Content.validate_blank?(must_params)

      content = Content.new(create_params)
      content.save!
    end
    return response, content
  end


  def self.update_by_params(params)
    content  = nil
    response = Response.rescue do |res|
      user       = params[:user]
      content_id = params[:content_id]
      res.raise_error("缺少参数") if content_id.blank?
      update_params = params.require(:update).permit!

      content = Content.find(content_id)

      res.raise_data_miss_error("content不存在") if content.blank?

      content.update_attributes!(update_params)
    end
    return response, content
  end


  def self.query_by_params(params)
    contents = nil
    response = Response.rescue do |res|
      page, per, search_param = params[:page], params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      contents                = Content.eager_load(:menu).search_by_params(search_param)
      if page.present?
        contents = contents.page(page).per(per)
      end
    end
    return response, contents
  end

  def self.delete_by_params(params)
    content  = nil
    response = Response.rescue do |res|
      content_id = params[:content_id]
      res.raise_error("参数缺失") if content_id.blank?
      content = Content.find(content_id)
      res.raise_data_miss_error("Content不存在") if content.blank?
      content.destroy!
    end
    return response
  end

end

