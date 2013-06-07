require File.expand_path("helper", File.dirname(__FILE__))

class PreloadTest < ActiveSupport::TestCase

  context Preload do

    setup do
      @blogs = Blog.all
      assert @blogs.size > 1
      clear_query_log
    end

    should "preload associations" do
      @blogs.each do |blog|
        assert !blog.posts.loaded?
      end

      @blogs.preload(:posts)

      @blogs.each do |blog|
        assert blog.posts.loaded?
      end
    end

    should "not do anything if the association is already preloaded" do
      @blogs.preload(:posts)

      assert_db_queries

      clear_query_log
      @blogs.preload(:posts)
      assert_no_db_queries

      @blogs = Blog.all(:include => :posts)
      clear_query_log
      @blogs.preload(:posts)
      assert_no_db_queries
    end

    should "support nested preloading" do
      @blogs.each do |blog|
        assert !blog.posts.loaded?
      end

      @blogs.preload(:posts => { :comments => { :author => {} } })

      clear_query_log

      @blogs.each do |blog|
        assert blog.posts.loaded?
        blog.posts.each do |post|
          assert post.comments.loaded?
          post.comments.each do |comment|
            assert comment.author.present?
          end
        end
      end

      assert_no_db_queries
    end

    if ActiveRecord::VERSION::STRING > "3.1.0"
      puts "Pending: preloading polymorphic does not work on #{ActiveRecord::VERSION::STRING}"
    else
      should "support nested polymorphic preloading" do
        @blogs.each do |blog|
          assert !blog.polies.loaded?
        end

        @blogs.preload([:polies => {}])

        clear_query_log

        @blogs.each do |blog|
          assert blog.polies.loaded?
        end

        assert_no_db_queries
      end
    end
  end
end
