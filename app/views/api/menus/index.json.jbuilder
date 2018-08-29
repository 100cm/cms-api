
json.menus do
      if @menus.present?
        render_json_array_partial(json,@menus,'api/common/menu',:menu)
      else
        {}
      end
end
