    if @template.present?
      json.template do
        render_json_attrs(json, @template)
      end
    else
      json.template {}
    end
