    json.content do
      if @content.present?
        render_json_attrs(json,@content)
      else
        {}
      end
    end

