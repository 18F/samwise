require 'spec_helper'
require 'samwise'

describe Samwise::Protocol do
  let(:api_key) { '123456' }
  let(:duns)    { '0123456780000'}

  it "should create the URL for the DUNS API endpoint" do
    duns_url = Samwise::Protocol.duns_url(duns: duns, api_key: api_key)

    expect(duns_url).to be_a_valid_url
  end
end
