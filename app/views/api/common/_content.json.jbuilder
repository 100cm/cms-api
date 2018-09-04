if content.present?
  render_json_attrs(json, content)
  json.cover content.cover&.url
else
  json.content {}
end

