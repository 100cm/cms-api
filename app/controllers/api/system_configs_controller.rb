class Api::SystemConfigsController < ApplicationController
  def index
    @response, @system_configs = SystemConfig.query_by_params params
  end

  def create
    @response, @system_config = SystemConfig.create_by_params params
  end

  def update
    @response, @system_config = SystemConfig.update_by_params params
  end

  def destroy
    @response = SystemConfig.delete_by_params params
  end

end

