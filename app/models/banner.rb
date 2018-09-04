class Banner < ApplicationRecord

  include BaseModelConcern

  mount_uploader :image, FileUploader

  def self.create_by_params(params)
    banner   = nil
    response = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!
      # 验证必填参数
      must_params = params.require(:create).values
      banner = Banner.new(create_params)
      banner.save!
    end
    return response, banner
  end


  def self.update_by_params(params)
    banner   = nil
    response = Response.rescue do |res|
      user      = params[:user]
      banner_id = params[:banner_id]
      res.raise_error("缺少参数") if banner_id.blank?
      update_params = params.require(:update).permit!

      banner = Banner.find(banner_id)
      if(update_params[:image].is_a?(String))
        update_params.except!(:image)
      end
      res.raise_data_miss_error("banner不存在") if banner.blank?
      banner.update_attributes!(update_params)
    end
    return response, banner
  end


  def self.query_by_params(params)
    banners  = nil
    response = Response.rescue do |res|
      page, per, search_param = params[:page] || 1, params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      banners                 = Banner.search_by_params(search_param).page(page).per(per)
    end
    return response, banners
  end

  def self.delete_by_params(params)
    banner   = nil
    response = Response.rescue do |res|
      banner_id = params[:banner_id]
      res.raise_error("参数缺失") if banner_id.blank?
      banner = Banner.find(banner_id)
      res.raise_data_miss_error("Banner不存在") if banner.blank?
      banner.destroy!
    end
    return response
  end

end

