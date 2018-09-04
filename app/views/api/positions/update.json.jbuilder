    json.position do
      if @position.present?
        render_json_attrs(json,@position)
      else
        {}
      end
    end

