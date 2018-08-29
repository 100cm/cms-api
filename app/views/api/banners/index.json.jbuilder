
json.banners do
      if @banners.present?
        render_json_array_partial(json,@banners,'api/common/banner',:banner)
      else
        {}
      end
end
