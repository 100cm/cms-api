class Api::PositionsController < ApplicationController
  def index
    @response, @positions = Position.query_by_params params
  end

  def create
    @response, @position = Position.create_by_params params
  end

  def update
    @response, @position = Position.update_by_params params
  end

  def destroy
    @response = Position.delete_by_params params
  end

end

