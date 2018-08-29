class Api::ContentsController < ApplicationController
  def index
    @response, @contents = Content.query_by_params params
  end

  def create
    @response, @content = Content.create_by_params params
  end

  def update
    @response, @content = Content.update_by_params params
  end

  def destroy
    @response = Content.delete_by_params params
  end

end

