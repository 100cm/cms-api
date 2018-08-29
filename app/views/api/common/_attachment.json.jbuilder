    if attachment.present?
      render_json_attrs(json, attachment)
    else
      json.attachment {}
    end

