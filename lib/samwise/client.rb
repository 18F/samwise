require 'json'
require 'httpclient'
require_relative './duns_lookup'

module Samwise
  class Client
    def initialize(api_key: nil, sam_status_key: Samwise::Protocol::SAM_STATUS_KEY)
      @api_key        = api_key        || ENV['DATA_DOT_GOV_API_KEY']
      @sam_status_key = sam_status_key || ENV['SAM_STATUS_KEY']
      @client = HTTPClient.new
    end

    def get_duns_info(duns: nil)
      response = lookup_duns(duns: duns)
      JSON.parse(response.body)
    end

    def get_vendor_summary(duns: nil)
      response = lookup_duns(duns: duns)

      {
        in_sam: parse_response_for_sam_status(response),
        small_business: small_business?(response)
      }
    end

    def duns_is_in_sam?(duns: nil)
      response = lookup_duns(duns: duns)
      parse_response_for_sam_status(response)
    end

    def get_sam_status(duns: nil)
      response = lookup_sam_status(duns: duns)
      JSON.parse(response.body)
    end

    def excluded?(duns: nil)
      response = lookup_duns(duns: duns)
      JSON.parse(response.body)["hasKnownExclusion"] == false
    end

    private

    def parse_response_for_sam_status(response)
      response.status == 200
    end

    def small_business?(response)
      Samwise::DunsLookup.new(response).small_business?
    end

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
