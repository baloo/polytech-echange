class Comment < Content
  belongs_to :announcement


  validates_presence_of :title,   :message => I18n.t(:comment_title_missing)
  validates_presence_of :body,    :message => I18n.t(:comment_body_missing)

  # Thread

  PATH_SIZE = 12  # Each id in the materialized_path is coded on 12 chars
  MAX_DEPTH = 1022 / PATH_SIZE


  after_create :generate_materialized_path

  def generate_materialized_path
    parent = Comment.find(parent_id) if parent_id.present?
    parent_path = parent ? parent.materialized_path : ''
    self.materialized_path = "%s%0#{PATH_SIZE}d" % [parent_path, self.id]
    save
  end

  attr_reader :parent_id

  def parent_id=(parent_id)
    @parent_id = parent_id
    return if parent_id.blank?
    parent = Comment.find(parent_id)
    self.title ||= parent ? "Re: #{parent.title}" : ''
  end

  def depth
    (materialized_path.length / PATH_SIZE) - 1
  end

  def root?
    depth == 0
  end




  # ACL 
  def creatable_by?(user)
    user
  end
  def editable_by?(user)
    user && (self.user == user)
  end
  def deletable_by?(user)
    user && (self.user == user)
  end

end
