class Api::TemplatesController < ApplicationController
  def index
    @response, @templates = Template.query_by_params params
  end

  def create
    @response, @template = Template.create_by_params params
  end

  def update
    @response, @template = Template.update_by_params params
  end

  def destroy
    @response = Template.delete_by_params params
  end

end

