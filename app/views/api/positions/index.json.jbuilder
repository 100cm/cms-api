
json.positions do
      if @positions.present?
        render_json_array_partial(json,@positions,'api/common/position',:position)
      else
        {}
      end
end
