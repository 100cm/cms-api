# frozen_string_literal: true
json.partial! 'api/common/response_status', response: @response
page_params = {}
instance_variables.each do |iv|
  begin
    object = self.instance_variable_get(iv)
    if object.respond_to?(:total_pages) && object.respond_to?(:total_count) && iv !=:@_config
      page_params.merge!({total_pages: object.total_pages, total_count: object.total_count})
    end
  rescue => e
    ylogi e
  end
end

json.data do
  json.merge! JSON.parse(yield)
  if page_params.present?
    json.merge! page_params
  end
end





