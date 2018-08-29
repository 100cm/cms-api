module Api::MenusHelper

  def render_loop_menu(json, menu)
    render_json_attrs(json, menu)
    json.children menu.children do |child|
      render_loop_menu(json, child)
    end
  end

end