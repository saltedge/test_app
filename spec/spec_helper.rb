require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "database_cleaner"
require "capybara/rspec"
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.before(:all) do
    DatabaseCleaner.start
  end
  config.after(:all) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Shoulda::Matchers::ActionController, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :request
  config.include FixturesHelper, type: :request
  config.include FixturesHelper, type: :controller
end
