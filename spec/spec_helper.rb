require 'rspec'
require 'tarly/version'
require 'rspec/expectations'
require 'uri'
require 'vcr'

include Tarly

RSpec::Matchers.define :be_a_valid_url do
  match do |actual|
    begin
      uri = URI.parse(actual)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end

  failure_message do |actual|
    "expected that #{actual} would be a valid url"
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<data_dot_gov_api_key>') { ENV['DATA_DOT_GOV_API_KEY'] }
end
