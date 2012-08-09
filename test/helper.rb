require 'rubygems'

require 'bundler'
Bundler.setup
Bundler.require(:default, :development)

if defined?(Debugger)
  ::Debugger.start
  ::Debugger.settings[:autoeval] = true if ::Debugger.respond_to?(:settings)
end

require 'test/unit'
require 'active_record'
require 'active_record/fixtures'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'preload'

require 'test_models'

$db_queries = []

ActiveRecord::Base.connection.class.class_eval do
  def execute_with_query_logger(query, name = nil)
    $db_queries << query
    execute_without_query_logger(query, name)
  end
  alias_method_chain :execute, :query_logger

  def exec_query_with_query_logger(sql, name = nil, binds = [])
    $db_queries << sql
    exec_query_without_query_logger(sql, name, binds)
  end
  alias_method_chain :exec_query, :query_logger if instance_methods.include?(:exec_query)
end

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures

  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end

  self.use_transactional_fixtures = true

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
$LOAD_PATH.unshift(ActiveSupport::TestCase.fixture_path)
ActiveSupport::TestCase.fixtures :all
