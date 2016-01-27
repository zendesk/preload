require_relative 'helper'

describe Preload do
  before do
    @blogs = Blog.all.to_a
    assert @blogs.size > 1
    clear_query_log
  end

  it "preloads associations" do
    @blogs.each do |blog|
      assert !blog.posts.loaded?
    end

    @blogs.pre_load(:posts)

    @blogs.each do |blog|
      assert blog.posts.loaded?
    end
  end

  it "does not do anything if the association is already preloaded" do
    @blogs.pre_load(:posts)

    assert_db_queries

    clear_query_log
    @blogs.pre_load(:posts)
    assert_no_db_queries

    @blogs = Blog.includes(:posts).to_a
    clear_query_log
    @blogs.pre_load(:posts)
    assert_no_db_queries
  end

  it "supports nested preloading" do
    @blogs.each do |blog|
      assert !blog.posts.loaded?
    end

    @blogs.pre_load(:posts => { :comments => { :author => {} } })

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

  it "mixes into WillPaginate::Collection" do
    collection = WillPaginate::Collection.new(1,1)
    assert collection.respond_to?(:pre_load)
  end

  it "supports nested polymorphic preloading" do
    pending("Pending: preloading polymorphic does not work on #{ActiveRecord::VERSION::STRING}") do
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


  def pending(reason)
    yield
  rescue Minitest::Assertion, StandardError
    skip reason
  else
    raise "Test passes"
  end
end
