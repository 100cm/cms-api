class Api::UsersController < ApplicationController
  def index
    @response, @users = User.query_by_params params
  end

  def create
    @response, @user = User.create_by_params params
  end

  def update
    @response, @user = User.update_by_params params
  end

  def destroy
    @response = User.delete_by_params params
  end

  def sign_in
    @response,@key = User.sign_in params
  end

end

