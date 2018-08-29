
json.system_configs do
      if @system_configs.present?
        render_json_array_partial(json,@system_configs,'api/common/system_config',:system_config)
      else
        {}
      end
end
