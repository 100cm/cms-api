class New < ApplicationRecord

  include BaseModelConcern

  mount_uploader :cover, FileUploader

  def self.create_by_params(params)
    new      = nil
    response = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!

      # 验证必填参数
      must_params = params.require(:create).values

      res.raise_error("缺少参数") if New.validate_blank?(must_params)

      new = New.new(create_params)
      new.save!
    end
    return response, new
  end


  def self.update_by_params(params)
    new      = nil
    response = Response.rescue do |res|
      user   = params[:user]
      new_id = params[:new_id]
      res.raise_error("缺少参数") if new_id.blank?
      update_params = params.require(:update).permit!

      new = New.find(new_id)

      if (update_params[:cover].is_a?(String))
        update_params.except!(:cover)
      end
      res.raise_data_miss_error("new不存在") if new.blank?

      new.update_attributes!(update_params)
    end
    return response, new
  end


  def self.query_by_params(params)
    news     = nil
    response = Response.rescue do |res|
      page, per, search_param = params[:page] || 1, params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      news                    = New.search_by_params(search_param).page(page).per(per)
    end
    return response, news
  end

  def self.delete_by_params(params)
    new      = nil
    response = Response.rescue do |res|
      new_id = params[:new_id]
      res.raise_error("参数缺失") if new_id.blank?
      new = New.find(new_id)
      res.raise_data_miss_error("New不存在") if new.blank?
      new.destroy!
    end
    return response
  end

end

