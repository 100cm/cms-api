    json.banner do
      if @banner.present?
        render_json_attrs(json,@banner)
      else
        {}
      end
    end

