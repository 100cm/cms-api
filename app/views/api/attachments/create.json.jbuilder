    if @attachment.present?
      json.attachment do
        render_json_attrs(json, @attachment)
      end
    else
      json.attachment {}
    end
