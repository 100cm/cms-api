    if @user.present?
      json.user do
        render_json_attrs(json, @user)
      end
    else
      json.user {}
    end
