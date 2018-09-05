if new.present?
  render_json_attrs(json, new)
  json.cover new.cover&.url
else
  json.new {}
end

