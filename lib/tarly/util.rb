require 'pry'

module Tarly
  module Util
    def self.format_duns(duns: duns)
      if duns.length == 9
        duns = "#{duns}0000"
      elsif duns.length == 8
        duns = "0#{duns}0000"
      end

      duns
    end
  end
end
