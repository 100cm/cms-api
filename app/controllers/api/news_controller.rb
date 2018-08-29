class Api::NewsController < ApplicationController
  def index
    @response, @news = New.query_by_params params
  end

  def create
    @response, @new = New.create_by_params params
  end

  def update
    @response, @new = New.update_by_params params
  end

  def destroy
    @response = New.delete_by_params params
  end

end

