if banner.present?
  render_json_attrs(json, banner)
  json.image banner.image&.url
else
  json.banner {}
end

