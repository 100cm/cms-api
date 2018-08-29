class Api::AttachmentsController < ApplicationController
  def index
    @response, @attachments = Attachment.query_by_params params
  end

  def create
    @response, @attachment = Attachment.create_by_params params
  end

  def update
    @response, @attachment = Attachment.update_by_params params
  end

  def destroy
    @response = Attachment.delete_by_params params
  end

  def ckeditor
    @attachment = Attachment.new(file: params[:upload])
    @attachment.save!
    if params[:type] == 'drag'
      render json: {
          "uploaded": 1,
          "fileName": @attachment.file.filename,
          "url":      @attachment.file.url
      }
    else
      render text: "<script type=\"text/javascript\">window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{@attachment.file.url}', '');</script>"

    end
  end

end

