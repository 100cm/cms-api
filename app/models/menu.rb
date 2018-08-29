class Menu < ApplicationRecord

  include BaseModelConcern

  has_many :children, foreign_key: 'parent_id', class_name: 'Menu'

  belongs_to :menu, foreign_key: 'parent_id', optional: true

  has_many :contents


  def self.create_by_params(params)
    menu     = nil
    response = Response.rescue do |res|
      user          = params[:user]
      create_params = params.require(:create).permit!
      menu          = Menu.new(create_params)
      menu.save!
    end
    return response, menu
  end


  def self.update_by_params(params)
    menu     = nil
    response = Response.rescue do |res|
      user    = params[:user]
      menu_id = params[:menu_id]
      res.raise_error("缺少参数") if menu_id.blank?
      update_params = params.require(:update).permit!

      menu = Menu.find(menu_id)

      res.raise_data_miss_error("menu不存在") if menu.blank?

      menu.update_attributes!(update_params)
    end
    return response, menu
  end


  def self.query_by_params(params)
    menus    = nil
    response = Response.rescue do |res|
      search_param = {} if search_param.blank?
      menus        = Menu.where(parent_id: nil).search_by_params(search_param)
    end
    return response, menus
  end

  def self.query_all_params(params)
    menus    = nil
    response = Response.rescue do |res|
      search_param = {} if search_param.blank?
      menus        = Menu.search_by_params(search_param)
    end
    return response, menus
  end

  def self.delete_by_params(params)
    menu     = nil
    response = Response.rescue do |res|
      menu_id = params[:menu_id]
      res.raise_error("参数缺失") if menu_id.blank?
      menu = Menu.find(menu_id)
      res.raise_data_miss_error("Menu不存在") if menu.blank?
      menu.destroy!
    end
    return response
  end

  def self.import_menus
    menu = [
        {
            title:    '关于星耀', code: '关于星耀',
            children: [
                          {title: 'BSE简介', code: 'BSE简介'},
                          {title: '校长寄语', code: '校长寄语'},
                          {title: '星耀理念', code: '星耀理念'},
                          {title: '新闻', type: 'new'},

                      ]
        },
        {
            title:    '星耀体系',
            children: [
                          {title: '学前部', code: '学前部'},
                          {title: 'k-12部', code: 'k-12部'},
                          {
                              title:    '课程研发部',
                              children: [
                                            {title: '艺术课程研发', code: '艺术课程研发'}
                                        ]
                          },
                          {title: 'BSE简介', code: 'BSE简介'},
                      ]
        },
        {
            title:    '投资合作事业部',
            children: [
                          {title: '投资方向', code: '投资方向'},
                          {title: '加盟体系', code: '加盟体系'},
                      ]
        },
        {
            title:    '加入我们',
            children: [{title: '招聘', code: '招聘'},]
        },
        {title: '联系我们', code: '联系我们'}
    ];
    menu.each do |menu_item|
      import_menu(menu_item)
    end
  end

  def self.import_menu(menu, parent_id = nil)
    menu_s = Menu.new(name: menu[:title], code: menu[:code], parent_id: parent_id)
    menu_s.save!

    if menu[:children].present?
      menu[:children].each do |child_menu|
        import_menu(child_menu, menu_s.id)
      end
    end

  end

end

