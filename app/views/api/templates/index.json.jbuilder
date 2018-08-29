
json.templates do
      if @templates.present?
        render_json_array_partial(json,@templates,'api/common/template',:template)
      else
        {}
      end
end
