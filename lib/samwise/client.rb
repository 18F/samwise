require 'faraday'
require 'json'
require 'httpclient'

module Samwise
  class Client
    def initialize(api_key: nil, sam_status_key: Samwise::Protocol::SAM_STATUS_KEY)
      @api_key        = api_key        || ENV['DATA_DOT_GOV_API_KEY']
      @sam_status_key = sam_status_key || ENV['SAM_STATUS_KEY']
      @conn = Faraday.new do |faraday|
        faraday.adapter :httpclient
      end
      @client = HTTPClient.new
    end

    def get_duns_info(duns: nil)
      response = lookup_duns(duns: duns)
      JSON.parse(response.body)
    end

    def duns_is_in_sam?(duns: nil)
      response = lookup_duns(duns: duns)
      response.status == 200
    end

    def get_sam_status(duns: nil)
      response = lookup_sam_status(duns: duns)
      JSON.parse(response.body)
    end

    def is_excluded?(duns: nil)
      response = lookup_duns(duns: duns)
      JSON.parse(response.body)["hasKnownExclusion"] == false
    end

    def is_small_business?(duns: nil, naicsCode: nil)
      response = lookup_duns(duns: duns)
      data = JSON.parse(response.body)["sam_data"]["registration"]["certifications"]["farResponses"]
      small_biz_array = data.find{|far|far["id"]=="FAR 52.219-1"}["answers"].find{"naics"}["naics"]

      # Allows for exact matches of a NAICS Code *or* NAICS code that starts with the argument. E.g., 541511 matches, but 54151 also matches
      small_biz_array.find{|naics|naics["naicsCode"].to_s.start_with?(naicsCode.to_s)}["isSmallBusiness"] == "Y"
    end

    private

    def lookup_duns(duns: nil)
      duns = Samwise::Util.format_duns(duns: duns)
      @client.get Samwise::Protocol.duns_url(duns: duns, api_key: @api_key)
    end

    def lookup_sam_status(duns: nil)
      duns = Samwise::Util.format_duns(duns: duns)
      @client.get Samwise::Protocol.sam_status_url(duns: duns, api_key: @api_key)
    end
  end
end
