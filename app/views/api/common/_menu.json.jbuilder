if menu.present?
  render_loop_menu(json, menu)
else
  json.menu {}
end

