class Api::BannersController < ApplicationController
  def index
    @response, @banners = Banner.query_by_params params
  end

  def create
    @response, @banner = Banner.create_by_params params
  end

  def update
    @response, @banner = Banner.update_by_params params
  end

  def destroy
    @response = Banner.delete_by_params params
  end

end

