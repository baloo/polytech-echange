# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(title, tag=nil)
    @title << title
  end

  def h2(str)
    title(str, :h2)
  end


end
