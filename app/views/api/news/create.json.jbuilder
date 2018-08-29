    if @new.present?
      json.new do
        render_json_attrs(json, @new)
      end
    else
      json.new {}
    end
