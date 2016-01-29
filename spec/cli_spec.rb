require 'spec_helper'
require 'samwise'
require 'json'
require 'Factory'

describe Samwise::Cli, vcr: { cassette_name: "Samwise::Client", record: :new_episodes } do
		let(:goodfile) {'spec/cli_mocks/test.json'}
		let(:badfile) {'-i spec/cli_mocks/bad.json'}
		let(:pipefile) {'cat '+goodfile}
		let(:flagfile) {'-i '+goodfile}
		let(:user_array) {Factory.create_users(["1000", "100"], ["080037478", "080031478"])}

		describe ".verify" do
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
				it "verifies the duns for each user" do
						expected = Factory.build_users_json(user_array, [{"verified":true}, {"verified":false}])+"\n"
						expect(`#{pipefile} | samwise verify`).to eq(expected)
						expect(`samwise verify #{flagfile}`).to eq(expected)
				end
				end

				context "given flagged bad json that doesn't include duns keys" do
				it "it request to recieve a good json" do
						expect(`samwise verify #{badfile}`).to eq("")
				end
				end
 		end

		#Continuous Integration
		describe ".excluded" do

				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
				it "adds a excluded field to " do
						expected = Factory.build_users_json(user_array, [{"excluded":false}, {"excluded":false}])+"\n"
						expect(`#{pipefile} | samwise excluded`).to eq(expected)
						expect(`samwise excluded #{flagfile}`).to eq(expected)
				end
				end

				context "given flagged bad json that doesn't include duns keys" do
				it "it request to recieve a good json" do
						expect(`samwise excluded #{badfile}`).to eq("")
				end
				end
		end

		describe ".get_info" do

				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
				it "gets the users' information and adds to the json " do
						expected = 'sam_data'
						expect(`#{pipefile} | samwise get_info`).to include(expected)
						expect(`samwise get_info #{flagfile}`).to include(expected)
				end
				end

				context "given flagged bad json that doesn't include duns keys" do
				it "it requests to recieve a good json" do
						expect(`samwise get_info #{badfile}`).to eq("")
				end
				end
		end

		describe ".check_format" do
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
				it "verifies that the duns number is formatted " do
						expected = Factory.build_users_json(user_array, [{"valid_format":true}, {"valid_format":true}])+"\n"
						expect(`#{pipefile} | samwise check_format`).to eq(expected)
						expect(`samwise check_format #{flagfile}`).to eq(expected)
				end
				end

				context "given flagged bad json that doesn't include duns keys" do
				it "it requests to recieve a good json" do
						expect(`samwise check_format #{badfile}`).to eq("")
				end
				end
		end

		describe ".format" do
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
				it "formats duns numbers in a json " do
						expected = Factory.build_users_json(user_array, [{"formatted_duns":"0800374780000"}, {"formatted_duns":"0800314780000"}])+"\n"
						expect(`#{pipefile} | samwise format`).to eq(expected)
						expect(`samwise format #{flagfile}`).to eq(expected)
				end
				end

				context "given flagged bad json that doesn't include duns keys" do
				it "it requests to recieve a good json" do
						expect(`samwise format #{badfile}`).to eq("")
				end
				end
		end

end
