    json.template do
      if @template.present?
        render_json_attrs(json,@template)
      else
        {}
      end
    end

