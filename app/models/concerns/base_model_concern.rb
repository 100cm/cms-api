# frozen_string_literal: true
module BaseModelConcern
  extend ActiveSupport::Concern

  def self.get_model(model_name)
    ActiveSupport::Dependencies.constantize(model_name.classify)
  end

  def self.params_blank?(params)
    !params.select { |_k, v| v.blank? }.empty?
  end

  module ClassMethods
    def is_my_task?(task_id, user_id, type)
      work = AtyunWorkflow::WorkFlow.new
      response = work.get_runtime_task(task_id)
      assigne_id = response['assignee']
      category = response['category']
      (assigne_id == user_id.to_s) && (type == category)
    end

    def get_model(model_name)
      ActiveSupport::Dependencies.constantize(model_name.classify)
    end

    def get_process_instance_id(task_id)
      work = AtyunWorkflow::WorkFlow.new
      response = work.get_runtime_task(task_id)
      response
    end

    def task_json

      AuditForm::AuditFormType.get_all_values.each do |type|
        puts "{text:'#{AuditForm::AuditFormType.get_desc_by_value(type)}',value:'#{type}' },"

      end
      return "ok"
    end

    def permit_params
      name = self.model_name.singular
      p = "("
      self.columns.each { |c|
        if (c.name != 'id')
          p+=":#{c.name},"
        end }
      p+=")"
      puts p
      return "ok"
    end

    def api_params
      name = self.model_name.singular
      self.columns.each { |c| puts "param :#{'"'+name+'['+c.name+']"' },String,desc: '#{c.comment}' " }
      return "ok"
    end

    # 获取字段的备注信息
    # 使用  User.column_comments  => hash
    def column_comments
      column_comments = self.connection.retrieve_column_comments(self.table_name)
      column_comments
    end

    # 使用  User.column_comment('username') => '用户名'
    def column_comment(column_name)
      column_name = column_name.to_s
      return '' unless self.column_names.include?(column_name)

      column_comments = self.connection.retrieve_column_comments(self.table_name)
      comment = column_comments[column_name.to_sym]
      comment
    end

    # 辅助方法 将传递进来的true  false 转换为 是 否
    def true_change(value = '')
      temp_value = value
      case value
        when true, 'true'
          temp_value = '是'
        when false, 'false'
          temp_value = '否'
        when 'un_pass'
          temp_value = '不通过'
        when 'pass'
          temp_value = '通过'
        when 'success'
          temp_value = '成功'
        when 'fail'
          temp_value = '失败'
        when 'change'
          temp_value = '课程确认'
        when 'modify'
          temp_value = '未通过'
        when 'file'
          temp_value = '失败，需补材料'
        when 'internet'
          temp_value = '在线申请'
        when 'paper'
          temp_value = '邮件申请'
        when 'other'
          temp_value = '线下支付'
        when 'liuyangbao'
          temp_value = '留洋宝支付'
        when 'provide_credit_card'
          temp_value = '提供信用卡信息'
        when 'provided', 'provided_cer'
          temp_value = '已提供'
        when 'un_provided'
          temp_value = '未提供'
        when '是'
          temp_value = true
        when '否'
          temp_value = false
        when 'institutional_feedback'
          temp_value = '院校反馈'
        when 'refusal'
          temp_value = '院校拒录取'
        when 'offer'
          temp_value = '成功'
        when 'success_enter'
          temp_value = '付费注册无条件'
        when 'fail_enter'
          temp_value = '付费注册有条件'
      end

      temp_value
    end

    # 获取七牛上传文件的凭证
    def get_upload_token
      put_policy = Qiniu::Auth::PutPolicy.new(
          CarrierwaveSetting.qiniu.bucket, # 存储空间
          nil, # 最终资源名，可省略，即缺省为“创建”语义
          1800, # 相对有效期，可省略，缺省为3600秒后 uptoken 过期
          (Time.now + 30.minutes).to_i # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试，这里表示半小时
      )

      uptoken = Qiniu::Auth.generate_uptoken(put_policy) #生成凭证
      bucket_domain = CarrierwaveSetting.qiniu.bucket_domain #存储空间名

      return uptoken, bucket_domain
    end


    def search_by_params(options = {})
      result = self.all
      if options.present?
        keys = options.keys
        keys.delete(:page)
        keys.delete(:per)
        keys.each do |key|
          value = options[key]
          next unless value.present? || !value.to_s.empty?
          if key == :order || key == 'order'
            orders = value.split(' ')
            result = if orders.length == 2
                       result.order("#{orders[0]} #{orders[1].upcase}")
                     else
                       result.order(value)
                     end
          elsif key.to_s.include?('like_')
            query = ''
            query_value = {}
            attr_key = key.to_s.gsub('like_', '')
            if attr_key.include?('.')
              ref_table = attr_key.split('.')[0]
              ref_key = attr_key.split('.')[1]

              if value.is_a?(Array)
                value.each_with_index do |v, i|
                  query += "#{attr_key} like :value#{i} "
                  query += 'or ' if i != value.length-1
                  query_value.merge!({"value#{i}": "%#{v}%"})
                end
                result = result.where(query, query_value)
              else
                result = result.where("#{attr_key} like ?", "%#{value}%")
              end
            else

              if value.is_a?(Array)
                value.each_with_index do |v, i|
                  query += "#{self.name.tableize}.#{attr_key} like :value#{i} "
                  query += 'or ' if i != value.length-1
                  query_value.merge!({"value#{i}": "%#{v}%"})
                end
                result = result.where(query, query_value)
              else
                result = result.where("#{self.name.tableize}.#{attr_key} like ?", "%#{value}%") if self.attribute_names.include?(attr_key)
              end
            end

            # or || 兼容   'students.creator_id'的情况发生   可能传递多个，超过两个
          elsif key.to_s =~ /^or_/
            attr_key = key.to_s.gsub('or_', '')
            values = value.split(' ')

            if attr_key.include?('.')
              search_key = "#{attr_key}" if value.present?
            else
              search_key = "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key) && value.present?
            end

            query_string = ''
            values.each_with_index do |v, i|
              query_string += "#{search_key} = '#{values[i]}' or "
            end
            query_string.chomp!(' or ')

            result = result.where(query_string)

            # or一个value同时搜多个参数
          elsif key.to_s.include?('&or&')
            # 这边的需求是搜索学校、代理、学生等的拼音名 所以需要同时搜name和name_pinyin 暂时默认是直接需要like的
            # 格式: 'schools.name&or&schools.full_name'
            attr_keys = key.to_s.split('&or&')
            if value.present?
              # query_string = ''
              query_hash = {value: "%#{value.upcase}%"}
              query_string = attr_keys.map.with_index do |attr_key, i|
                convert_key = if attr_key.include?('.')
                                attr_key
                              else
                                "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key)
                              end
                convert_key_arr = convert_key.split('.')
                # 用self的话会有问题
                key_type = convert_key_arr.first.classify.constantize.type_for_attribute(convert_key_arr.last).type.to_s.classify
                key_type == String.name ? "upper(#{convert_key}) like :value or " : "#{convert_key} = :value or "
              end.flatten.join[0..-5]
              result = result.where(query_string, query_hash)
            end
          elsif key.to_s =~ /^compare_/
            attr_key = key.to_s.gsub(/^compare_/, '')
            if value.present?
              query_hash = {}
              query_string = ""
              if attr_key =~ /^lt_/
                attr_key.gsub!(/^lt_/, '')
                convert_key = if attr_key.include?('.')
                                attr_key
                              else
                                "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key)
                              end
                query_hash = {value: "#{value.to_d}"}
                query_string = "#{convert_key} <= :value "
              elsif attr_key =~ /^bt_/
                attr_key.gsub!(/^bt_/, '')
                convert_key = if attr_key.include?('.')
                                attr_key
                              else
                                "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key)
                              end
                query_hash = {min: "#{value.split(' ')[0]}", max: "#{value.split(' ')[1]}"}
                query_string = "#{convert_key} >= :min and #{convert_key} <= :max "
              elsif attr_key =~ /^gt_/
                attr_key.gsub!(/^gt_/, '')
                convert_key = if attr_key.include?('.')
                                attr_key
                              else
                                "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key)
                              end
                query_hash = {value: "#{value.to_d}"}
                query_string = "#{convert_key} >= :value "
              end
              result = result.where(query_string, query_hash)
            end
            #between
          elsif key.to_s.include?('between_')
            attr_key = key.to_s.gsub('between_', '')
            front, back = value.split(',')
            # 这里需要兼容只填写了一个日期的情况
            if (front =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/ || front =~ /^\d{4}-\d{2}-\d{2}$/) && value[-1].blank?
              convert_key = if attr_key.include?('.')
                              attr_key
                            else
                              "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key)
                            end
              query_hash = {value: "#{front.to_date.midnight}"}
              query_string = "#{convert_key} >= :value "
              result = result.where(query_string, query_hash)
            elsif (front =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/ || front =~ /^\d{4}-\d{2}-\d{2}$/) && value[0].blank?
              convert_key = if attr_key.include?('.')
                              attr_key
                            else
                              "#{self.name.tableize}.#{attr_key}" if self.attribute_names.include?(attr_key)
                            end
              query_hash = {value: "#{front.to_date.end_of_day}"}
              query_string = "#{convert_key} <= :value "
              result = result.where(query_string, query_hash)
            else
              if (front =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/ && back =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/) || (front =~ /^\d{4}-\d{2}-\d{2}$/ && back =~ /^\d{4}-\d{2}-\d{2}$/)
                front = front.to_date.midnight
                back = back.to_date.end_of_day
              end
              if attr_key.include?('.')
                result = result.between_fields("#{attr_key}", front, back) if value.present? && value.split(',').length == 2
              else
                result = result.between_fields("#{self.name.tableize}.#{attr_key}", front, back) if self.attribute_names.include?(attr_key) && value.present? && value.split(',').length == 2
              end
            end
          elsif key.to_s.include?('not_')
            attr_key = key.to_s.gsub('not_', '')
            result = result.where.not("#{attr_key} = ?", "#{value}")
          else
            key = key.to_s.remove('between_').remove('like_').remove('not_')
            if key.include?('.')
              result = result.where(key.to_sym => value)
            else
              result = result.where("#{self.name.tableize}.#{key}".to_sym => value) if self.attribute_names.include?(key)
            end
          end
        end
      end
      result
    end

    def resources_search_by_params(resources, options = {})
      result = resources
      if options.present?
        keys = options.keys
        keys.delete(:page)
        keys.delete(:per)
        keys.each do |key|
          value = options[key]
          next unless value.present? || !value.to_s.empty?
          if key == :order || key == 'order'
            orders = value.split(' ')

            result = if orders.length == 2
                       result.order(orders[0].to_sym => orders[1].to_sym)
                     else
                       result.order(value)
                     end
          else
            result = result.where(key.to_sym => value) if result.model.instance_methods.include?(key) || result.model.attribute_names.include?(key.to_s)
            if key.to_s.include?('like_')
              attr_key = key.to_s.gsub('like_', '')
              if attr_key.include?('.')
                result = result.where("#{attr_key} like ?", "%#{value}%")
              else
                result = result.where("#{result.model.name.tableize}.#{attr_key} like ?", "%#{value}%") if result.model.attribute_names.include?(attr_key)
              end
            end
          end
        end
      end
      result
    end

    def search_by_hash(args, result_objects = nil)
      result = result_objects.present? ? result_objects : self.all

      if args.present?
        args.each_key do |key|
          value = args[key]

          next unless value.present? || !value.to_s.empty?

          result = result.where("#{self.name.tableize}.#{key} like ?", "%#{args[key]}%") if self.attribute_names.include?(key)
        end
      end

      result
    end

    def validate_present?(params)
      params.select(&:present?).empty?
    end

    def validate_blank?(params)
      return true if params.blank?
      !params.select(&:blank?).empty?
    end

    def validate_all_present?(*args)
      args.select(&:blank?).empty?
    end

    def validate_all_blank?(*args)
      return true if args.blank?
      args.select(&:present?).empty?
    end

    def exist_resource(resource_id)
      return nil if resource_id.blank?

      self.find_by_id(resource_id)
    end

    # 为简单的对象保存记录
    # 作者  liangyuzhe 20161225
    def save_values_for_object(options)
      record = nil
      response = Response.rescue do |_res|
        column_sym = (self.columns.map(&:name) - %w(id deleted_at created_at updated_at)).map(&:to_sym)
        hash = {}
        column_sym.each do |c|
          hash.merge!(c => options[c])
        end
        record = self.create!(hash)
      end
      [response, record]
    end

    # postgresql查询jsonb数据方法
    # params white_list String Array
    # params params ActionController::Parameters
    # params jsonb_column_name string
    # 作者  liangyuzhe 20170108
    #
    def search_by_action_controller_params_for_jsonb(params, white_list, column_name)
      if white_list.present?
        if white_list.is_a? String
          permitted = params.permit(white_list)
        elsif white_list.is_a? Array
          permitted = {}
          white_list.each { |w| permitted.merge!(params.permit(w)) if w.is_a? String }
        end
      end
      if permitted.present?
        find_result(permitted.to_json, column_name)
      else
        self.all
      end
    rescue => e
      yloge e, '传入的数据有问题'
    end

    # 得到数据方法
    def find_result(permitted, column_name)
      query = nil
      self.columns.map(&:name).each do |c|
        if column_name == c
          query = self.where("#{column_name} @> :permitted", permitted: permitted)
        end
      end
      query
    rescue => e
      yloge e, '传入的数据有问题'
    end


    def hash_keys_to_symbol(hash)
      {}.tap do |h|
        hash.each { |key, value| h[key.to_sym] = map_value(value) }
      end
    end
  end

  # 为简单的对象更新记录
  # 作者  liangyuzhe 20161225
  def update_values_for_object(options)
    record = nil
    response = Response.rescue do |_res|
      column_sym = (self.class.columns.map(&:name) - %w(id deleted_at created_at updated_at)).map(&:to_sym)
      hash = {}
      column_sym.each do |c|
        hash.merge!(c => options[c]) if options[c].present?
      end
      record = self.update!(hash)
    end
    [response, record]
  end

  #构造查询条件
  def self.build_search(options= {})
    if options.present?
      search_string = "where "
      keys = options.keys
      keys.each do |key|
        value = options[key]
        Rails.logger.info ">>>> build_search key: #{key.to_s}"
        Rails.logger.info ">>>> build_search value: #{value.to_s}"

        next unless (value.present? || !value.to_s.empty?) and value != "''" and !value.blank?
        #模糊查询
        if key.to_s.include?('like_')
          attr_key = key.to_s.gsub('like_', '')
          str = "#{attr_key} like '%#{value}%'"

          #否定查询
        elsif key.to_s.include?('no_')
          attr_key = key.to_s.gsub('no_', '')
          if attr_key == 'academic_category'
            str = "#{attr_key} != '#{value.upcase}'"
          else
            str = "#{attr_key} not like '%#{value}%'"
          end

          #按日期区间查询
        elsif key.to_s.include?('between_')
          attr_key = key.to_s.gsub('between_', '')
          date_array = value.split(',').collect { |item| item.tr('/', '-') }
          str = ''
          if date_array.size > 1
            str = "#{attr_key} between '#{date_array[0]}' and '#{date_array[1]}'"
          elsif value[0].blank?
            str = "#{attr_key} <= '#{date_array[0]}'"
          elsif value[-1].blank?
            str = "#{attr_key} >= '#{date_array[0]}'"
          end

          #   #由于数据存在异常 用于特定的按月查询
          # elsif key.to_s.include?('special_')
          #   attr_key = key.to_s.gsub('special_', '')
          #   begin_month = value.split(' ')[0]
          #   end_month = value.split(' ')[1]
          #   str = "(#{attr_key} between '#{begin_month}' and '#{end_month}' or in_account_time_month between '#{begin_month}' and '#{end_month}')"

          #由于数据存在异常 用于特定的按月查询
        elsif key.to_s.include?('special_')
          attr_key = key.to_s.gsub('special_', '')
          date_array = value.split.collect { |item| item.tr('/', '-') }
          str = ''
          if date_array.size > 1
            str = "(#{attr_key} between '#{date_array[0]}' and '#{date_array[1]}' or in_account_time_month between '#{date_array[0]}' and '#{date_array[1]}')"
          elsif value[0].blank?
            str = "(#{attr_key} <= '#{date_array[0]}' or in_account_time_month <= '#{date_array[0]}')"
          elsif value[-1].blank?
            str = "(#{attr_key} >= '#{date_array[0]}' or in_account_time_month >= '#{date_array[0]}')"
          end

        elsif key.to_s.end_with?('_id')
          str = ''
          if value.size > 0
            tmp = value.map { |item| item.to_i }.to_s
            tmp.tr!('[', '(')
            tmp.tr!(']', ')')
            str = "#{key} in #{tmp}"
          end

          #多选模糊查询
        elsif key.to_s.include?('multi_')
          str = ""
          attr_key = key.to_s.gsub('multi_', '')
          value.each do |a|
            next unless a.present?
            tmp = "#{attr_key} like '%#{a}%'"
            if a != value.first and str != ""
              tmp = " or " + tmp
            end
            str += tmp
          end
          str = "(#{str})"
        else
          if key == 'academic_category'
            str = "#{key} = '#{value.upcase}'"
          else
            str = "#{key.to_s}='#{value}'"
          end
        end
        if key != options.keys.first and search_string != "where "
          str = " and " + str
        end

        search_string += str
      end
      if search_string == "where "
        search_string = ""
      end
      # log(search_string)
      return search_string
    end
  end

  module AttributeType
    DECIMAL = 'decimal'
    STRING = 'string'
    DATE = 'date'
  end

  def generate_pinyin_when_create
    if self.deleted_at.blank?
      self.class.attribute_names.each do |attribute|
        self[attribute.intern] = PinYin.of_string(self[attribute.remove('_pinyin').intern]).join if attribute.include?('_pinyin')
      end
    end
  end

end
