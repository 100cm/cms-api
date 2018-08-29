
json.attachments do
      if @attachments.present?
        render_json_array_partial(json,@attachments,'api/common/attachment',:attachment)
      else
        {}
      end
end
