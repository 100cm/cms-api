    if @position.present?
      json.position do
        render_json_attrs(json, @position)
      end
    else
      json.position {}
    end
