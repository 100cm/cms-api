    if @banner.present?
      json.banner do
        render_json_attrs(json, @banner)
      end
    else
      json.banner {}
    end
