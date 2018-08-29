    json.user do
      if @user.present?
        render_json_attrs(json,@user)
      else
        {}
      end
    end

