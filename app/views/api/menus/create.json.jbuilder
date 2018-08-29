    if @menu.present?
      json.menu do
        render_json_attrs(json, @menu)
      end
    else
      json.menu {}
    end
