# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #include WillPaginate::ViewHelpers 
  def title(title, tag=nil)
    @title << title
    content_tag(tag, title) if tag
  end

  def h2(str)
    title(str, :h2)
  end

  def article_for(record, &blk)
    content_tag_for(:article, record, :class => 'content', &blk)
  end

  def posted_by(content)
    user = content.user || current_user
    if user
      user_link = link_to(user.login, user)
      #TODO : localize datetime
      date_time = (content.created_at || DateTime.now).to_s(:posted)
      t :posted_by, {:user => user_link, :date => date_time}
    end
  end



  #def will_paginate_with_i18n(collection, options = {}) 
  #  will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next))) 
  #end 

  #alias_method_chain :will_paginate, :i18n  
end
