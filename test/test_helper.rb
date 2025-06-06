ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
require "webmock/minitest"
require "mocha/minitest"

WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  ActiveRecord::Migration.maintain_test_schema!

  # Use Minitest Reporters
  reporter_options = {color: true}
  Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(reporter_options)]
end
