require File.expand_path("helper", File.dirname(__FILE__))

class PreloadTest < ActiveSupport::TestCase

  context Preload do

    should "preload associations" do
      blogs = Blog.all

      assert blogs.size > 1

      blogs.each do |blog|
        assert !blog.posts.loaded?
      end

      blogs.preload(:posts)

      blogs.each do |blog|
        assert blog.posts.loaded?
      end
    end
  end

end
