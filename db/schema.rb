# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181013011514) do

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image"
    t.string   "desc"
    t.string   "seq"
    t.string   "link"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "category"
    t.string   "content_name"
    t.string   "child_category"
    t.string   "background",                                                                comment: "背景"
    t.string   "title",                                                                     comment: "标题"
    t.string   "subtitle",                                                                  comment: "副标题"
    t.string   "banner",                                                                    comment: "banner"
    t.text     "page_content",              limit: 65535,                                   comment: "页面内容"
    t.string   "cover",                                                                     comment: "封面"
    t.integer  "template_id",                                                               comment: "模板id"
    t.integer  "seq",                                     default: 0
    t.boolean  "show_child",                              default: true
    t.string   "status",                                  default: "active"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "country_id"
    t.string   "link",                                                                      comment: "链接"
    t.integer  "parent_id"
    t.string   "theme"
    t.integer  "nav_id"
    t.string   "nav_link"
    t.string   "layout",                                  default: "common"
    t.integer  "col",                                     default: 24
    t.datetime "deleted_at"
    t.string   "background_color"
    t.string   "content_category"
    t.string   "height"
    t.string   "width"
    t.string   "background_filter",                       default: "normal"
    t.boolean  "background_filter_global",                default: false
    t.string   "desc",                                                                      comment: "描述"
    t.integer  "plugin_id"
    t.string   "data_mode",                               default: "static"
    t.string   "business_category",                                                         comment: "行业"
    t.string   "used_category",                           default: "personal",              comment: "类型"
    t.integer  "creator_id",                                                                comment: "创建人id"
    t.integer  "updater_id",                                                                comment: "修改人"
    t.string   "circle_type",                                                               comment: "圆角类型"
    t.string   "menu_color",                                                                comment: "菜单颜色"
    t.string   "selected_color",                                                            comment: "选中底色"
    t.integer  "clip_path_left"
    t.integer  "clip_path_right"
    t.string   "link_plate",                                                                comment: "链接板块"
    t.string   "alignment",                               default: "",                      comment: "对齐方式"
    t.boolean  "is_tiling",                               default: false,                   comment: "是否平铺"
    t.boolean  "is_locked",                               default: false,                   comment: "是否锁定"
    t.boolean  "overlay_effect",                          default: false,                   comment: "叠加效果"
    t.string   "selected_animation_effect",               default: "",                      comment: "选中动画效果"
    t.integer  "deep_template_id",                                                          comment: "根template的id"
    t.integer  "user_id"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "menu_id"
    t.index ["deleted_at"], name: "index_contents_on_deleted_at", using: :btree
  end

  create_table "menus", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "menu_category"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "status",        default: "active"
    t.string   "parent_menu"
    t.string   "code"
    t.string   "name_en"
  end

  create_table "news", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "content",    limit: 65535
    t.string   "desc"
    t.string   "status"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "time"
    t.string   "cover"
  end

  create_table "positions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "age"
    t.string   "sex"
    t.text     "requirement", limit: 65535
    t.text     "work_time",   limit: 65535
    t.string   "money"
    t.string   "location"
    t.text     "benefit",     limit: 65535
    t.string   "contact"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "session_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "session_key"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "system_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "logo"
    t.string   "location"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "menu_id"
    t.string   "template_theme"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
