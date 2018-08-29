    if content.present?
      render_json_attrs(json, content)
    else
      json.content {}
    end

