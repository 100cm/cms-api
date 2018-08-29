    if new.present?
      render_json_attrs(json, new)
    else
      json.new {}
    end

