require 'spec_helper'
require 'samwise'

describe Samwise::Client, vcr: { cassette_name: "Samwise::Client", record: :new_episodes } do
  let(:api_key)           { ENV['DATA_DOT_GOV_API_KEY'] }
  let(:nine_duns)         { '809102507' }
  let(:eight_duns)        { '78327018' }
  let(:thirteen_duns)     { '0223841150000' }
  let(:not_in_sam_duns)   { '08-011-5718' }
  let(:valid_dunses)      { [nine_duns, eight_duns, thirteen_duns] }
  let(:non_existent_duns) { '0000001000000' }
  let(:client)            { Samwise::Client.new(api_key: api_key) }
  let(:naics_code)        { 54151 }
  let(:full_naics_code)   { 541511 }
  let(:big_biz_duns)      { '1459697830000' }
  let(:bad_dunses) do
    [
      '1234567890',
      '12345678901',
      '123456789011',
      '1',
      '',
      '--',
      '12345678901234567890'
    ]
  end

  describe '#get_vendor_summary' do
    it 'returns a hash containing in_sam and small_business keys' do
      response = client.get_vendor_summary(duns: nine_duns)

      expect(response).to have_key(:in_sam)
      expect(response).to have_key(:small_business)
    end

    context 'when the DUNS belongs to a small business' do
      it 'has small_business set to true' do
        response = client.get_vendor_summary(duns: nine_duns)

        expect(response[:small_business]).to eq(true)
      end
    end

    context 'when the DUNS belongs to a big business' do
      it 'has small_business set to false' do
        response = client.get_vendor_summary(duns: big_biz_duns)

        expect(response[:small_business]).to eq(false)
      end
    end

    context 'when the DUNS is in SAM' do
      it 'has in_sam set to true' do
        response = client.get_vendor_summary(duns: nine_duns)

        expect(response[:in_sam]).to eq(true)
      end
    end

    context 'when the DUNS is not in SAM' do
      it 'has in_sam set to false' do
        response = client.get_vendor_summary(duns: non_existent_duns)

        expect(response[:in_sam]).to eq(false)
      end
    end
  end

  context '#get_sam_status' do
    it 'should return a Hash given a valid DUNS number' do
      skip 'until SSL issues can be addressed'
      valid_dunses.each do |valid_duns|
        expect(client.get_sam_status(duns: valid_duns)).to be_a(Hash)
      end
    end

    it 'should return a Hash given a DUNS not in SAM' do
      skip 'until SSL issues can be addressed'
      expect(client.get_sam_status(duns: not_in_sam_duns)).to be_a(Hash)
    end

    it 'should raise a Samwise::Error::InvalidFormat error given an invalid DUNS number' do
      bad_dunses.each do |bad_duns|
        expect do
          client.get_sam_status(duns: bad_duns)
        end.to raise_error(Samwise::Error::InvalidFormat)
      end
    end

  end

  context '#duns_is_in_sam?' do
    it "should verify that a 9 digit DUNS number exists in sam.gov" do
      response = client.duns_is_in_sam?(duns: nine_duns)

      expect(response).to be(true)
    end

    it "should verify that an 8 digit DUNS number exists in sam.gov" do
      response = client.duns_is_in_sam?(duns: eight_duns)

      expect(response).to be(true)
    end

    it "should verify that a 13 digit DUNS number exists in sam.gov" do
      response = client.duns_is_in_sam?(duns: thirteen_duns)

      expect(response).to be(true)
    end

    it "should return false given a DUNS number that is not in sam.gov" do
      response = client.duns_is_in_sam?(duns: non_existent_duns)

      expect(response).to be(false)
    end

    it 'should raise a Samwise::Error::InvalidFormat error given an invalid DUNS number' do
      bad_dunses.each do |bad_duns|
        expect do
          client.duns_is_in_sam?(duns: bad_duns)
        end.to raise_error(Samwise::Error::InvalidFormat)
      end
    end

  end

  context '#get_duns_info' do
    it "should get info for a 9 digit DUNS number" do
      response = client.get_duns_info(duns: nine_duns)

      expect(response).to be_a(Hash)
    end

    it "should get info for an 8 digit DUNS number" do
      response = client.get_duns_info(duns: eight_duns)

      expect(response).to be_a(Hash)
    end

    it "should get info for a 13 digit DUNS number" do
      response = client.get_duns_info(duns: thirteen_duns)

      expect(response).to be_a(Hash)
    end

    it "should return an error given a DUNS number that is not in sam.gov" do
      response = client.get_duns_info(duns: non_existent_duns)

      expect(response).to be_a(Hash)
      expect(response['Error']).to eq('Not Found')
    end

    it 'should raise a Samwise::Error::InvalidFormat error given an invalid DUNS number' do
      bad_dunses.each do |bad_duns|
        expect do
          client.get_duns_info(duns: bad_duns)
        end.to raise_error(Samwise::Error::InvalidFormat)
      end
    end
  end

  context '#is_excluded?' do
    it "should verify that vendor in the system is not on the excluded vendor list in sam.gov" do
      response = client.excluded?(duns: nine_duns)
      expect(response).to be(false)
    end
  end

  context '#small_business?' do
    context 'the DUNS belongs to a big business' do
      it 'should return false' do
        response = client.small_business?(duns: big_biz_duns)
        expect(response).to be(false)
      end
    end

    context 'the DUNS belongs to a small business' do
      it 'should return true' do
        response = client.small_business?(duns: nine_duns)
        expect(response).to be(true)
      end
    end
  end
end
