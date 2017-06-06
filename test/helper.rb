require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/rg'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'preload'

require_relative 'test_models'

$db_queries = []

ActiveRecord::Base.connection.class.class_eval do
  def execute_with_query_logger(query, *args)
    $db_queries << query
    execute_without_query_logger(query, *args)
  end
  alias_method :execute_without_query_logger, :execute
  alias_method :execute, :execute_with_query_logger

  def exec_query_with_query_logger(sql, *args)
    $db_queries << sql
    exec_query_without_query_logger(sql, *args)
  end
  if instance_methods.include?(:exec_query) || instance_methods.include?('exec_query')
    alias_method :exec_query_without_query_logger, :exec_query
    alias_method :exec_query, :exec_query_with_query_logger
  end
end

# Use ActiveSupport::TestCase for everything that was not matched before
MiniTest::Spec::DSL::TYPES[-1] = [//, ActiveSupport::TestCase]

class ActiveSupport::TestCase
  extend MiniTest::Spec::DSL
    include ActiveRecord::TestFixtures

  if ActiveRecord::VERSION::MAJOR < 5
    self.use_transactional_fixtures = true
  else
    self.use_transactional_tests = true
  end

  self.use_instantiated_fixtures  = false

  def clear_query_log
    $db_queries.clear
  end

  setup :clear_query_log

  def assert_no_db_queries
    assert $db_queries.empty?, "expected no db queries, but these where done #{$db_queries.inspect}"
  end

  def assert_db_queries
    assert !$db_queries.empty?, "expected db queries, but none were made"
  end
end

ActiveSupport::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
ActiveSupport::TestCase.fixtures :all
ActiveSupport.test_order = :random if ActiveSupport.respond_to?(:test_order=)
