    if @content.present?
      json.content do
        render_json_attrs(json, @content)
      end
    else
      json.content {}
    end
