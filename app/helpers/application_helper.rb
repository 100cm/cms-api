# encoding: UTF-8
# frozen_string_literal: true

module ApplicationHelper
  #
  # 渲染json返回属性
  #
  # @param json [Unknown] json对象
  # @param obj [ActiveRecord] 数据库表的对象
  # @param attrs [Array] 需要渲染的表属性符号数组
  #
  def render_json_attrs(json, obj, attrs = nil)
    # Rails.logger.info "obj=>#{obj}"
    if attrs.blank?
      attrs = obj.class.columns.map(&:name)
    end
    attrs.each do |column|
      next unless   column != 'deleted_at'
      key = column.to_sym
      column_type = obj.class.columns.select { |c| c.name == column.to_s }.first.type
      value = obj.__send__(column.to_sym)
      if value.present?
        value = value.to_time&.strftime('%F') if key.to_s == 'date' || key.to_s.include?('_date')
        # 兼容代码
        value = value.to_time&.strftime('%F %H:%M') if key.to_s =~ /_at$/ || key.to_s =~ /_time$/

        # if (/^([a-zA-Z]+_)*id$/ =~ key).present? || key.to_s == 'whodunnit'
        #   if value.class == Array
        #     value = value.map { |v| v }
        #   else
        #     value = value
        #   end
        # end
      else
        value = ''
        value = false if value != true && column_type == :boolean
      end
      json.__send__(key, value)
    end
  end

  def render_json_attrs_except(json, object, attrs = nil)
    attrs = object.class.columns.map(&:name) - (attrs.map { |x| x.to_s }) if attrs.present?

    render_json_attrs(json, object, attrs)
  end

  def render_json_array_partial(obj, array, particle, as)
    obj.__send__('array!', array, partial: particle, as: as)
  end

  #
  # 将准确时间转换成相对于当前的时间
  #
  def timeago(time)
    return '' if time.blank?

    if time.is_a?(String)
      time = begin
        Time.parse(time)
      rescue
        ''
      end
    elsif time.is_a?(Time)
      time = time
    end

    return '' if time.blank?

    time_now = Time.now

    interval = (time_now - time).to_i

    case interval
    when 0..3600
      minutes = interval / 60

      time = I18n.t('timeago.minutes', minutes: minutes)

    when 3601..86_400
      hours = interval / 3600

      time = I18n.t('timeago.hours', hours: hours)

    when 86_401..2_592_000
      days = interval / 86_400

      time = I18n.t('timeago.days', days: days)

    else
      time = time.strftime('%F %H:%M')
    end

    time
  end

  def current_user(user_session_key)
    user_string = $redis.get(user_session_key)
    user = JSON.parse(user_string, object_class: OpenStruct)
    user
  end

  def get_model(model_name)
    ActiveSupport::Dependencies.constantize(model_name.classify)
  end

end
