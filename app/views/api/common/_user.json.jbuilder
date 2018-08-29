    if user.present?
      render_json_attrs(json, user)
    else
      json.user {}
    end

