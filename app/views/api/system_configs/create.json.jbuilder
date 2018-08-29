    if @system_config.present?
      json.system_config do
        render_json_attrs(json, @system_config)
      end
    else
      json.system_config {}
    end
