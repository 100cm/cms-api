
json.contents do
      if @contents.present?
        render_json_array_partial(json,@contents,'api/common/content',:content)
      else
        {}
      end
end
