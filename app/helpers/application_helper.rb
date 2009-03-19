# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #include WillPaginate::ViewHelpers 
  def title(title, tag=nil)
    @title << title
  end

  def h2(str)
    title(str, :h2)
  end



  #def will_paginate_with_i18n(collection, options = {}) 
  #  will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next))) 
  #end 

  #alias_method_chain :will_paginate, :i18n  
end
