
json.news do
      if @news.present?
        render_json_array_partial(json,@news,'api/common/new',:new)
      else
        {}
      end
end
