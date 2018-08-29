class Api::MenusController < ApplicationController
  def index
    @response, @menus = Menu.query_by_params params
  end

  def all
    @response, @menus = Menu.query_all_params params
  end

  def create
    @response, @menu = Menu.create_by_params params
  end

  def update
    @response, @menu = Menu.update_by_params params
  end

  def destroy
    @response = Menu.delete_by_params params
  end

end

