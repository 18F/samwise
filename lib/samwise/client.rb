require 'json'
require 'httpclient'

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

    def duns_is_in_sam?(duns: nil, delay: 1)
      sleep(delay)
      response = lookup_duns(duns: duns)
      response.status == 200
    end

    def get_sam_status(duns: nil)
      response = lookup_sam_status(duns: duns)
      JSON.parse(response.body)
    end

    def excluded?(duns: nil)
      response = lookup_duns(duns: duns)
      JSON.parse(response.body)["hasKnownExclusion"] == false
    end

    def small_business?(duns: nil)
      response = lookup_duns(duns: duns)
      data = JSON.parse(response.body)["sam_data"]["registration"]

      far_responses = data['certifications']['farResponses']
      response_to_small_biz = far_responses.find do |response|
        response['id'] == Samwise::Protocol::FAR_SMALL_BIZ_CITATION
      end

      answers = response_to_small_biz['answers']

      naics_answers = answers.find {|answer| answer.has_key?('naics')}['naics']
      small_business_naics_answers = naics_answers.select do |answer|
        Samwise::Protocol::NAICS_WHITELIST.include?(answer['naicsCode'])
      end

      !small_business_naics_answers.detect do |answer|
        answer['isSmallBusiness'] == 'Y'
      end.nil?
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
