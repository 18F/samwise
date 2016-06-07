module Samwise
  class DunsLookup
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def small_business?
      if response.status == 200
        small_business_response
      else
        false
      end
    end

    private

    def small_business_response
      if registration_data && certifications && far_responses
        small_business_response?
      else
        false
      end
    end

    def small_business_response?
      !small_business_naics_answers.detect do |answer|
        answer['isSmallBusiness'] == 'Y'
      end.nil?
    end

    def small_business_naics_answers
      naics_answers.select do |answer|
        Samwise::Protocol::NAICS_WHITELIST.include?(answer['naicsCode'])
      end
    end

    def naics_answers
      small_business_answers.find do |answer|
        answer.has_key?('naics')
      end['naics']
    end

    def small_business_answers
      response_to_small_business_questions['answers']
    end

    def response_to_small_business_questions
      far_responses.find do |far_response|
        far_response['id'] == Samwise::Protocol::FAR_SMALL_BIZ_CITATION
      end
    end

    def far_responses
      certifications['farResponses']
    end

    def certifications
      registration_data['certifications']
    end

    def registration_data
      @_data ||= JSON.parse(response.body)["sam_data"]["registration"]
    end
  end
end
