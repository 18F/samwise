module Samwise
  module Protocol
    SAM_API_BASE_URL    = 'https://api.data.gov'
    SAM_API_API_VERSION = 'v4'
    SAM_STATUS_URL      = 'https://www.sam.gov/samdata/registrations/trackProgress'
    SAM_STATUS_KEY      = '1452031543862'

    def self.duns_url(duns: nil, api_key: nil)
      fail Samwise::Error::ArgumentMissing, 'DUNS number is missing' if duns.nil?
      fail Samwise::Error::ArgumentMissing, 'SAM.gov API key is missing' if api_key.nil?

      "#{SAM_API_BASE_URL}/sam/#{SAM_API_API_VERSION}/registrations/#{duns}?api_key=#{api_key}"
    end

    def self.sam_status_url(duns: nil, api_key: nil)
      fail Samwise::Error::ArgumentMissing, 'DUNS number is missing' if duns.nil?
      fail Samwise::Error::ArgumentMissing, 'SAM status key is missing' if api_key.nil?

      "#{SAM_STATUS_URL}/?duns=#{duns}&_=#{api_key}"
    end
  end
end
