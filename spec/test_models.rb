class Post < ActiveRecord::Base
  validates_presence_of :summary
  acts_as_content_highlightable_on :summary
end

class User < ActiveRecord::Base
end
