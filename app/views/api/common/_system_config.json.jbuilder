    if system_config.present?
      render_json_attrs(json, system_config)
    else
      json.system_config {}
    end

