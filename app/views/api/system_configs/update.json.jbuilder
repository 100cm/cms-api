    json.system_config do
      if @system_config.present?
        render_json_attrs(json,@system_config)
      else
        {}
      end
    end

