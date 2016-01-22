require "thor"
require 'json'

# require 'samwise'

module Samwise
  class Cli < Thor
    method_option :infile, :aliases => "-i", :desc => "Nonpiped version input"
    # method_option :dunsnum, :aliases => "-d", :desc => "DUNS number"
    desc "verify", "Verify DUNS numbers are in SAM.gov"
    def verify
      wrap_sam("verified"){|c, u, j| u[j] = c.duns_is_in_sam?(duns: u['duns'])}
    end
    method_option :infile, :aliases => "-i", :desc => "Nonpiped version input"
    desc "excluded", "Verify Vendor is not on the excluded parties list"
    def excluded
      wrap_sam("excluded"){|c, u, j| u[j] = c.is_excluded?(duns: u['duns'])}
    end
    
    method_option :infile, :aliases => "-i", :desc => "Nonpiped version input"
    desc "get_info", "Get DUNS info"
    def get_info
      wrap_sam("user_info"){|c, u, j| u[j] = c.get_duns_info(duns: u['duns'])}
    end

    method_option :infile, :aliases => "-i", :desc => "Nonpiped version input"
    desc "check_format", "Validate the format of a DUNS number"
    def check_format
      wrap_sam("valid_format"){|c, u, j| u[j] = Samwise::Util.duns_is_properly_formatted?(duns: u['duns'])}
    end

    method_option :infile, :aliases => "-i", :desc => "Nonpiped version input"
    desc "format", "Format a DUNS number"
    def format
        wrap_sam("formatted_duns") {|c, u, j| u[j] = Samwise::Util.format_duns(duns: u['duns'])}
    end

    #Helpers
    desc "private method wrap_sam JSonkeytoadd &block", "Opens the client and cli files for all of the calls"
    def wrap_sam(jsonOutKey, &block)
      #read in a json of users to be samwised
      infile = (STDIN.tty?) ? File.read(options[:infile]) : $stdin.read
      duns_hash = JSON.parse(infile)
      #check what method called wrap_sam. Do not init samwise client for utils
      thor_method = caller_locations(1,1)[0].label
      client = Samwise::Client.new unless (thor_method == "check_format") || (jsonOutKey =="format")

        
     duns_hash['users'].each do |user|
      #abort process do improperly formated duns
     abort("please use a .json with a duns key") unless user.has_key?("duns")
     block.call(client, user, jsonOutKey)
     end
     puts duns_hash.to_json
        
    end

    private :wrap_sam

  end
end
