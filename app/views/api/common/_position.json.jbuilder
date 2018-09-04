    if position.present?
      render_json_attrs(json, position)
    else
      json.position {}
    end

