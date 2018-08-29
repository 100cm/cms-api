    json.menu do
      if @menu.present?
        render_json_attrs(json,@menu)
      else
        {}
      end
    end

