require 'faraday'
require 'json'

module Tarly
  class Sam
    def initialize(api_key: api_key)
      @api_key = api_key || ENV['DATA_DOT_GOV_API_KEY']
    end

    def get_duns_info(duns: nil)
      response = lookup_duns(duns: duns)
      JSON.parse(response.body)
    end

    def duns_is_valid?(duns: nil)
      response = lookup_duns(duns: duns)
      response.status == 200
    end

    private

    def lookup_duns(duns: duns)
      duns = Tarly::Util.format_duns(duns: duns)
      response = Faraday.get(Tarly::Protocol.duns_url(duns: duns, api_key: @api_key))
    end
  end
end
