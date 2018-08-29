# frozen_string_literal: true
require 'rails/generators'
namespace :crud do
  task g: :environment do
    require 'fileutils'
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_view_file(path, content)
        create_file path, content
      end

      def add_routes(args)
        route("
namespace :api do
    resources :#{args}
end
")
      end
    end

    namespace = ARGV[2]

    arg1 = ARGV[1]
    args = arg1.pluralize
    path = Rails.root.join('app', 'models', "#{arg1}.rb")
    file = File.new(path, 'w')
    model = arg1.classify

    InstallGenerator.new.add_routes args

    file.write <<-File
class #{model} < ApplicationRecord

  include BaseModelConcern

  def self.create_by_params(params)
    #{arg1} = nil
    response = Response.rescue do |res|
      user = params[:user]
      create_params = params.require(:create).permit!

      # 验证必填参数
      must_params = params.require(:create).values

      res.raise_error("缺少参数") if #{model}.validate_blank?(must_params)

      #{arg1} = #{model}.new(create_params)
      #{arg1}.save!
    end
    return response, #{arg1}
  end


  def self.update_by_params(params)
    #{arg1}= nil
    response = Response.rescue do |res|
      user = params[:user]
      #{arg1}_id = params[:#{arg1}_id]
      res.raise_error("缺少参数") if #{arg1}_id.blank?
      update_params = params.require(:update).permit!

      #{arg1} = #{model}.find(#{arg1}_id)

      res.raise_data_miss_error("#{arg1}不存在") if #{arg1}.blank?

      #{arg1}.update_attributes!(update_params)
    end
    return response, #{arg1}
  end


  def self.query_by_params(params)
    #{args} = nil
    response = Response.rescue do |res|
      page, per, search_param = params[:page] || 1, params[:per] || 5, params[:search]
      search_param = {} if search_param.blank?
      #{args} = #{model}.search_by_params(search_param).page(page).per(per)
    end
    return response, #{args}
  end

  def self.delete_by_params(params)
    #{arg1} = nil
    response = Response.rescue do |res|
      #{arg1}_id = params[:#{arg1}_id]
      res.raise_error("参数缺失")  if #{arg1}_id.blank?
      #{arg1} = #{model}.find(#{arg1}_id)
      res.raise_data_miss_error("#{model}不存在") if #{arg1}.blank?
      #{arg1}.destroy!
    end
    return response
  end

end

    File
    con_path = Rails.root.join('app', 'controllers', 'api', "#{args}_controller.rb")

    con_file = <<-File
class Api::#{model.pluralize}Controller < ApplicationController
  def index
    @response, @#{args} = #{model}.query_by_params params
  end

  def create
    @response, @#{arg1} = #{model}.create_by_params params
  end

  def update
    @response, @#{arg1} = #{model}.update_by_params params
  end

  def destroy
    @response = #{model}.delete_by_params params
  end

end

    File

    InstallGenerator.new.create_view_file(con_path, con_file)

    index_view_path = Rails.root.join('app', 'views', 'api', args.to_s, 'index.json.jbuilder')
    common_view_path = Rails.root.join('app', 'views', 'api', 'common', "_#{arg1}.json.jbuilder")
    update_view_path = Rails.root.join('app', 'views', 'api', args.to_s, 'update.json.jbuilder')
    create_view_path = Rails.root.join('app', 'views', 'api', args.to_s, 'create.json.jbuilder')
    delete_view_path = Rails.root.join('app', 'views', 'api', args.to_s, 'destroy.json.jbuilder')

    index_content = <<-File

json.#{args} do
      if @#{args}.present?
        render_json_array_partial(json,@#{args},'api/common/#{arg1}',:#{arg1})
      else
        {}
      end
end
    File

    # index_view_file = File.new(index_view_path, 'w')
    # create_view_file = File.new(create_view_path, 'w')
    # update_view_file = File.new(update_view_path, 'w')
    # common_view_file = File.new(common_view_path, 'w')
    # destroy_view_file = File.new(delete_view_path, 'w')

    # index_view_file.write

    common_view_content = <<-File
    if #{arg1}.present?
      render_json_attrs(json, #{arg1})
    else
      json.#{arg1} {}
    end

        File

    create_view_content = <<-File
    if @#{arg1}.present?
      json.#{arg1} do
        render_json_attrs(json, @#{arg1})
      end
    else
      json.#{arg1} {}
    end
        File
    #
    update_view_content = <<-File
    json.#{arg1} do
      if @#{arg1}.present?
        render_json_attrs(json,@#{arg1})
      else
        {}
      end
    end

        File

    InstallGenerator.new.create_view_file(index_view_path, index_content)
    InstallGenerator.new.create_view_file(create_view_path, create_view_content)
    InstallGenerator.new.create_view_file(update_view_path, update_view_content)
    InstallGenerator.new.create_view_file(common_view_path, common_view_content)
    InstallGenerator.new.create_view_file(delete_view_path, '')
  end
end
