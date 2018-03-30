RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with :deletion
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

# config.before(:suite) do
#     DatabaseCleaner.clean_with(:truncation)
#   end

#   config.before(:each) do |example|
#     DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
#     DatabaseCleaner.start
#   end

#   config.after(:each) do
#     DatabaseCleaner.clean
#   end