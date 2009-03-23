class Announcement < Content
  ### Workflow
  # Setup
  acts_as_state_machine :initial => :draft, :column => 'status'

  # States
  state :draft #Initial state
  state :published
  state :refused
  state :deleted

  # Events
  event :delete do
    transitions :to => :deleted, :from => [:published]
  end
  event :accept do
    transitions :to => :published, :from => [:draft]
  end
  event :refuse do
    transitions :to => :refused, :from => [:draft]
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
