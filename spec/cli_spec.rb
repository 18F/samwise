require 'spec_helper'
require 'samwise'
require 'json'
require 'factory'
require 'stringio'

describe Samwise::Cli, vcr: { cassette_name: "Samwise::Cli", record: :new_episodes } do
		let(:goodfile) {'spec/cli_mocks/test.json'}
		let(:piped_file){$stdin = StringIO.new(File.read(goodfile))}
		let(:badfile) {'spec/cli_mocks/bad.json'}
		let(:user_array) {Factory.create_users(["1000", "100"], ["080037478", "080031478"])}
		let(:abort_msg) {'please use a .json with a duns key'}
		def output(method, file)
			capture(:stdout){Samwise::Cli.new.invoke(method, [], {:infile => file})}
		end

		after(:example) do
			$stdin = STDIN
		end
		describe ".verify" do
				let(:method) {:verify}
				let(:verified_user) {Factory.build_users_json(user_array, [{"verified":true}, {"verified":false}])+"\n"}
				it "verifies the duns for each user with streamed infile" do
						piped_file
						expect(output(method, goodfile)).to eq(verified_user)
				end
				it "verifies the duns for each user when given an -i flagged test.json with duns key" do
					expect(output(method, goodfile)).to eq(verified_user)
				end

				it "requests to recieve a good json when recieves json without duns key" do
					begin
						err = capture_stderr(output(method, badfile))
					rescue Exception => e
						expect(e.to_s).to eq(abort_msg)
					end
				end

 		end

		describe ".excluded" do
				let(:method) {:excluded}
				let(:excluded_user){Factory.build_users_json(user_array, [{"excluded":false}, {"excluded":false}])+"\n"}
				it "checks if users are excluded for each user in a streamed infile" do
						piped_file
						expect(output(method, goodfile)).to eq(excluded_user)
				end

				it "checks if users are excluded when given an -i flagged test.json with duns key" do
						expect(output(method, goodfile)).to eq(excluded_user)
				end

				it "requests to recieve a good json when recieves json without duns key" do
					begin
						output(method, badfile)
					rescue Exception => e
						expect(e.to_s).to eq(abort_msg)
					end
				end
		end

		describe ".get_info" do
				let(:method){:get_info}
				let(:expected_info) {"sam_data"}
				it "gets the users' information for each user in a streamed infile" do
						piped_file
						expect(output(method, goodfile)).to include(expected_info)
				end

				it "gets the users' information and adds to the json when given an -i flagged test.json with duns key" do
						expect(output(method, goodfile)).to include(expected_info)
				end

				it "requests to recieve a good json when recieves json without duns key" do
					begin
						output(method, badfile)
					rescue Exception => e
						expect(e.to_s).to eq(abort_msg)
					end
				end
		end

		describe ".check_format" do
				let(:method) {:check_format}
				let(:valid_duns){Factory.build_users_json(user_array, [{"valid_format":true}, {"valid_format":true}])+"\n"}
				it "verifies that the each duns number is formatted for each user in a streamed infile" do
						piped_file
						expect(output(method, goodfile)).to eq(valid_duns)
				end

				it "verifies that the each duns number is formatted for -i flagged test.json with duns key" do
						expect(output(method, goodfile)).to eq(valid_duns)
				end

				it "requests to recieve a good json when recieves json without duns key" do
						begin
							output(method, badfile)
						rescue Exception => e
							expect(e.to_s).to eq(abort_msg)
						end
				end

		end

		describe ".format" do
			let(:method) {:format}
			let(:format_duns){Factory.build_users_json(user_array, [{"formatted_duns":"0800374780000"}, {"formatted_duns":"0800314780000"}])+"\n"}
			it "formats duns numbers when streamed in json with users array and duns key" do
					piped_file
					expect(output(method, goodfile)).to eq(format_duns)
			end

			it "formats duns numbers when given an -i flagged test.json with duns key " do
					expect(output(method, goodfile)).to eq(format_duns)
			end

			it "requests to recieve a good json when recieves json without duns key" do
				begin
					output(method, badfile)
				rescue Exception => e
					expect(e.to_s).to eq(abort_msg)
				end
			end
		end
end
