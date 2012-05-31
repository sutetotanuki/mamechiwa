ENV["RAILS_ENV"] = "test"

$:.unshift File.expand_path("../lib", __FILE__)

require "mamechiwa"
require "active_record"
require "database_cleaner"

ActiveRecord::Base.establish_connection('adapter' => 'mysql2', 'database' => 'mamechiwa_test')

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

# CreateMamechiwaTests.down rescue ActiveRecord::StatementInvalid
# CreateMamechiwaTests.up

# CreateGroups.down rescue ActiveRecord::StatementInvalid
# CreateGroups.up

# CreateGroups.down rescue ActiveRecord::StatementInvalid
# CreateGroups.up

Dir[File.join(File.dirname(__FILE__), "support/migration/*.rb")].each do |f|
  migration_class_name = File.basename(f, ".rb").camelize
  migration_class = self.class.const_get(migration_class_name)
  migration_class.down rescue ActiveRecord::StatementInvalid
  migration_class.up
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
