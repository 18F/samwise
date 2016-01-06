require 'spec_helper'
require 'samwise'

describe Samwise::Client, vcr: { cassette_name: "Samwise::Client", record: :new_episodes } do
  let(:api_key)           { ENV['DATA_DOT_GOV_API_KEY'] }
  let(:nine_duns)         { '809102507' }
  let(:eight_duns)        { '78327018' }
  let(:thirteen_duns)     { '0223841150000' }
  let(:non_existent_duns) { '0000001000000' }

  context '#duns_is_in_sam?' do
    it "should verify that a 9 digit DUNS number exists in sam.gov" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.duns_is_in_sam?(duns: nine_duns)

      expect(response).to be(true)
    end

    it "should verify that an 8 digit DUNS number exists in sam.gov" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.duns_is_in_sam?(duns: eight_duns)

      expect(response).to be(true)
    end

    it "should verify that a 13 digit DUNS number exists in sam.gov" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.duns_is_in_sam?(duns: thirteen_duns)

      expect(response).to be(true)
    end

    it "should return false given a DUNS number that is not in sam.gov" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.duns_is_in_sam?(duns: non_existent_duns)

      expect(response).to be(false)
    end
  end

  context '#get_duns_info' do
    it "should get info for a 9 digit DUNS number" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.get_duns_info(duns: nine_duns)

      expect(response).to be_a(Hash)
    end

    it "should get info for an 8 digit DUNS number" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.get_duns_info(duns: eight_duns)

      expect(response).to be_a(Hash)
    end

    it "should get info for a 13 digit DUNS number" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.get_duns_info(duns: thirteen_duns)

      expect(response).to be_a(Hash)
    end

    it "should return an error given a DUNS number that is not in sam.gov" do
      client = Samwise::Client.new(api_key: api_key)
      response = client.get_duns_info(duns: non_existent_duns)

      expect(response).to be_a(Hash)
      expect(response['Error']).to eq('Not Found')
    end
  end
end
