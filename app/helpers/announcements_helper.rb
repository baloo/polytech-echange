module AnnouncementsHelper
  def title(title)
    @title = title
  end

  def h2(str)
    title(str)
  end
end
