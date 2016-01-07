require 'pry'

module Samwise
  module Util
    def self.duns_is_properly_formatted?(duns: nil)
      return false if duns.nil?

      duns = duns.gsub('-', '')

      return true if duns_contains_forbidden_characters?(duns: duns)

      return true if duns_is_eight_digits?(duns: duns)
      return true if duns_is_nine_digits?(duns: duns)
      return true if duns_is_thirteen_digits?(duns: duns)

      return false
    end

    def self.format_duns(duns: nil)
      raise Samwise::Error::InvalidFormat unless duns_is_properly_formatted?(duns: duns)

      duns = duns.gsub('-', '')

      if duns_is_nine_digits?(duns: duns)
        duns = "#{duns}0000"
      elsif duns_is_eight_digits?(duns: duns)
        duns = "0#{duns}0000"
      end

      duns
    end

    def self.duns_contains_forbidden_characters?(duns: nil)
      duns.split('').each do |character|
        return false if self.string_is_numeric?(string: character)
      end

      false
    end

    def self.string_is_numeric?(string: nil)
      string.split('').each do |character|
        return false unless character.to_i.to_s == character
      end

      return true
    end

    def self.duns_is_eight_digits?(duns: nil)
      duns.length == 8
    end

    def self.duns_is_nine_digits?(duns: nil)
      duns.length == 9
    end

    def self.duns_is_thirteen_digits?(duns: nil)
      duns.length == 13
    end
  end
end
