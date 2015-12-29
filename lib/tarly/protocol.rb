module Tarly
  module Protocol
    BASE_URL = "https://api.data.gov"
    API_VERSION = "v1"

    def self.duns_url(duns: duns, api_key: api_key)
      "#{BASE_URL}/sam/#{API_VERSION}/registrations/#{duns}?api_key=#{api_key}"
    end
  end
end
