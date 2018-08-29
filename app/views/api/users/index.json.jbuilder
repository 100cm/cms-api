
json.users do
      if @users.present?
        render_json_array_partial(json,@users,'api/common/user',:user)
      else
        {}
      end
end
