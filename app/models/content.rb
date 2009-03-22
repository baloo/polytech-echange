class Content < ActiveRecord::Base
  belongs_to :user


  self.abstract_class = true

end
