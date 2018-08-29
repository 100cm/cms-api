    if template.present?
      render_json_attrs(json, template)
    else
      json.template {}
    end

