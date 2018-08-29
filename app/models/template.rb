class Template < ApplicationRecord

  include BaseModelConcern

  has_many :contents

  belongs_to :menu

  def self.create_by_params(params)
    template = nil
    response = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!

      # 验证必填参数
      must_params = params.require(:create).values

      res.raise_error("缺少参数") if Template.validate_blank?(must_params)

      template = Template.new(create_params)
      template.save!
    end
    return response, template
  end


  def self.update_by_params(params)
    template = nil
    response = Response.rescue do |res|
      user        = params[:user]
      template_id = params[:template_id]
      res.raise_error("缺少参数") if template_id.blank?
      update_params = params.require(:update).permit!

      template = Template.find(template_id)

      res.raise_data_miss_error("template不存在") if template.blank?

      template.update_attributes!(update_params)
    end
    return response, template
  end


  def self.query_by_params(params)
    templates = nil
    response  = Response.rescue do |res|
      page, per, search_param = params[:page] || 1, params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      templates               = Template.search_by_params(search_param).page(page).per(per)
    end
    return response, templates
  end

  def self.delete_by_params(params)
    template = nil
    response = Response.rescue do |res|
      template_id = params[:template_id]
      res.raise_error("参数缺失") if template_id.blank?
      template = Template.find(template_id)
      res.raise_data_miss_error("Template不存在") if template.blank?
      template.destroy!
    end
    return response
  end

end

