require 'rspec'
require 'samwise/version'
require 'rspec/expectations'
require 'uri'
require 'vcr'
require 'webmock/rspec'


include Samwise

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
  end

  def stdin_init(file)
    before(:context) do
      $stdin = StringIO.new(File.read(file))
    end

    after(:context) do
      $stdin = STDIN
    end
  end

  def capture_stderr(&block)
  original_stderr = $stderr
  $stderr = fake = StringIO.new
  begin
    yield
  ensure
    $stderr = original_stderr
  end
  fake.string
  end

end

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
