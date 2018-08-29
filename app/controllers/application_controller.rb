class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :check_handle, only: [:create, :update, :destroy]

  def check_handle
    key           = params[:user_session_key]
    params[:user] = SessionKey.where(session_key: key).first
    if params[:user].blank?
      render json: {status: {code: "50000", message: 'user error'}}
    end
  end

end
