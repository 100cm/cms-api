class SystemConfig < ApplicationRecord

  include BaseModelConcern

  def self.create_by_params(params)
    system_config = nil
    response      = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!

      system_config = SystemConfig.find_by_id(create_params[:id])

      if system_config.blank?
        system_config = SystemConfig.new(create_params)
        system_config.save!
      else
        system_config.update_attributes!(create_params)
      end

    end
    return response, system_config
  end


  def self.update_by_params(params)
    system_config = nil
    response      = Response.rescue do |res|
      user             = params[:user]
      system_config_id = params[:system_config_id]
      res.raise_error("缺少参数") if system_config_id.blank?
      update_params = params.require(:update).permit!

      system_config = SystemConfig.find(system_config_id)

      res.raise_data_miss_error("system_config不存在") if system_config.blank?

      system_config.update_attributes!(update_params)
    end
    return response, system_config
  end


  def self.query_by_params(params)
    system_configs = nil
    response       = Response.rescue do |res|
      page, per, search_param = params[:page] || 1, params[:per] || 5, params[:search]
      search_param            = {} if search_param.blank?
      system_configs          = SystemConfig.search_by_params(search_param).page(page).per(per)
    end
    return response, system_configs
  end

  def self.delete_by_params(params)
    system_config = nil
    response      = Response.rescue do |res|
      system_config_id = params[:system_config_id]
      res.raise_error("参数缺失") if system_config_id.blank?
      system_config = SystemConfig.find(system_config_id)
      res.raise_data_miss_error("SystemConfig不存在") if system_config.blank?
      system_config.destroy!
    end
    return response
  end

end

