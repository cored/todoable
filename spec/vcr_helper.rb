require "vcr"

VCR.configure do |config|
  # Setup default vcr cassettes files
  config.cassette_library_dir = "spec/fixtures/casettes"

  # Setup http mock library
  config.hook_into :webmock

  # Setup rspec metadata
  config.configure_rspec_metadata!

  config.filter_sensitive_data("TODOABLE_USERNAME") { "<HIDDEN_USER>" }
  config.filter_sensitive_data("TODOABLE_PASSWORD") { "<HIDDEN_PASS>" }
end
