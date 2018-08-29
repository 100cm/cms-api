class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string   "category"
      t.string   "content_name"
      t.string   "child_category"
      t.string   "background",                                                  comment: "背景"
      t.string   "title",                                                       comment: "标题"
      t.string   "subtitle",                                                    comment: "副标题"
      t.string   "banner",                                                      comment: "banner"
      t.text     "page_content",                                                comment: "页面内容"
      t.string   "cover",                                                       comment: "封面"
      t.integer  "template_id",                                                 comment: "模板id"
      t.integer  "seq",                       default: 0
      t.boolean  "show_child",                default: true
      t.string   "status",                    default: "active"
      t.string   "resource_type"
      t.integer  "resource_id"
      t.integer  "country_id"
      t.string   "link",                                                        comment: "链接"
      t.integer  "parent_id"
      t.string   "theme"
      t.integer  "nav_id"
      t.string   "nav_link"
      t.string   "layout",                    default: "common"
      t.integer  "col",                       default: 24
      t.datetime "deleted_at"
      t.string   "background_color"
      t.string   "content_category"
      t.string   "height"
      t.string   "width"
      t.string   "background_filter",         default: "normal"
      t.boolean  "background_filter_global",  default: false
      t.string   "desc",                                                        comment: "描述"
      t.integer  "plugin_id"
      t.string   "data_mode",                 default: "static"
      t.string   "business_category",                                           comment: "行业"
      t.string   "used_category",             default: "personal",              comment: "类型"
      t.integer  "creator_id",                                                  comment: "创建人id"
      t.integer  "updater_id",                                                  comment: "修改人"
      t.string   "circle_type",                                                 comment: "圆角类型"
      t.string   "menu_color",                                                  comment: "菜单颜色"
      t.string   "selected_color",                                              comment: "选中底色"
      t.integer  "clip_path_left"
      t.integer  "clip_path_right"
      t.string   "link_plate",                                                  comment: "链接板块"
      t.string   "alignment",                 default: "",                      comment: "对齐方式"
      t.boolean  "is_tiling",                 default: false,                   comment: "是否平铺"
      t.boolean  "is_locked",                 default: false,                   comment: "是否锁定"
      t.boolean  "overlay_effect",            default: false,                   comment: "叠加效果"
      t.string   "selected_animation_effect", default: "",                      comment: "选中动画效果"
      t.integer  "deep_template_id",                                            comment: "根template的id"
      t.integer  "user_id"
      t.index ["deleted_at"], name: "index_contents_on_deleted_at", using: :btree
      t.timestamps
    end
  end
end
