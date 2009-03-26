class Threads
  attr_reader :comment
  attr_reader :children

  # Build a thread with the given comments
  def initialize(comment)
    @comment  = comment
    @children = []
  end

  # Add a child
  def <<(child)
    @children << child
  end

  # Return the threads with all the comments for the given node
  def self.all(announcement_id)
    comments = Comment.all(:conditions => ['announcement_id = ? AND materialized_path IS NOT NULL', announcement_id], :order => 'materialized_path ASC')
    please_make_me_a_tree(comments)
  end

protected

  # All the magic is here!
  def self.please_make_me_a_tree(comments)
    roots, threads = [], []
    comments.each do |comment|
      thread = self.new(comment)
      if comment.root?
        threads = []
        roots << thread
      else
        (threads.length - comment.depth).times { threads.pop }
        threads.last << thread
      end
      threads << thread
    end
    roots
  end

end

