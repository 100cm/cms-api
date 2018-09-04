class Position < ApplicationRecord

  include BaseModelConcern

  def self.create_by_params(params)
    position = nil
    response = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!

      # 验证必填参数
      must_params = params.require(:create).values

      res.raise_error("缺少参数") if Position.validate_blank?(must_params)

      position = Position.new(create_params)
      position.save!
    end
    return response, position
  end


  def self.update_by_params(params)
    position = nil
    response = Response.rescue do |res|
      user        = params[:user]
      position_id = params[:position_id]
      res.raise_error("缺少参数") if position_id.blank?
      update_params = params.require(:update).permit!

      position = Position.find(position_id)

      res.raise_data_miss_error("position不存在") if position.blank?

      position.update_attributes!(update_params)
    end
    return response, position
  end


  def self.query_by_params(params)
    positions = nil
    response  = Response.rescue do |res|
      page, per, search_param = params[:page], params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      positions               = Position.search_by_params(search_param)

      if page.present?
        positions = positions.page(page).per(per)
      end
    end
    return response, positions
  end

  def self.delete_by_params(params)
    position = nil
    response = Response.rescue do |res|
      position_id = params[:position_id]
      res.raise_error("参数缺失") if position_id.blank?
      position = Position.find(position_id)
      res.raise_data_miss_error("Position不存在") if position.blank?
      position.destroy!
    end
    return response
  end

end

