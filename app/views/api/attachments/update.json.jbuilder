    json.attachment do
      if @attachment.present?
        render_json_attrs(json,@attachment)
      else
        {}
      end
    end

