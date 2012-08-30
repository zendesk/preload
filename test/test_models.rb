# ActiveRecord::Base.logger = Logger.new($stdout)
# ActiveRecord::Base.logger.level = Logger::DEBUG

ActiveRecord::Base.configurations = YAML::load(IO.read(File.expand_path("database.yml", File.dirname(__FILE__))))

ActiveRecord::Base.establish_connection('test')
load(File.dirname(__FILE__) + "/schema.rb")

class Comment < ActiveRecord::Base
  belongs_to :post
  has_one :author, :through => :post
end

class Author < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :blog
  belongs_to :author
  has_many :comments
  belongs_to :poly, :polymorphic => true
end

class Blog < ActiveRecord::Base
  has_many :posts
  has_many :comments, :through => :posts
  has_many :polies, :class_name => "Post", :as => :poly
end
