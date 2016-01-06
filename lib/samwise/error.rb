module Samwise
  module Error
    class InvalidFormat < StandardError
      def initialize(message: 'The format of the provided DUNS number is invalid')
        super(message)
      end
    end
  end
end
