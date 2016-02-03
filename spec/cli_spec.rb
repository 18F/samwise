require 'spec_helper'
require 'samwise'
require 'json'
require 'Factory'
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
				context "given an -i flagged test.json that includes correct keys" do
					it "verifies the duns for each user" do
						expect(output(method, goodfile)).to eq(verified_user)
					end
				end

				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "verifies the duns for each user" do
							piped_file
							expect(output(method, goodfile)).to eq(verified_user)
					end
				end

				context "given flagged bad json that doesn't include duns keys" do
					it "it request to recieve a good json" do
						begin
							output(method, badfile)
						rescue Exception => e
							expect(e.to_s).to eq(abort_msg)
						end
					end
				end
 		end

		describe ".excluded" do
				let(:method) {:excluded}
				let(:excluded_user){Factory.build_users_json(user_array, [{"excluded":false}, {"excluded":false}])+"\n"}
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "adds a excluded field to " do
							piped_file
							expect(output(method, goodfile)).to eq(excluded_user)
					end
				end

				context "given an -i flagged input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "adds a excluded field to " do
							expect(output(method, goodfile)).to eq(excluded_user)
					end
				end

				context "given flagged bad json that doesn't include duns keys" do
					it "it request to recieve a good json" do
						begin
							output(method, badfile)
						rescue Exception => e
							expect(e.to_s).to eq(abort_msg)
						end
					end
				end
		end

		describe ".get_info" do
				let(:method){:get_info}
				let(:expected_info) {"sam_data"}
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "gets the users' information and adds to the json " do
							piped_file
							expect(output(method, goodfile)).to include(expected_info)
					end
				end

				context "given an -i flagged input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "gets the users' information and adds to the json " do
							expect(output(method, goodfile)).to include(expected_info)
					end
				end

				context "given flagged bad json that doesn't include duns keys" do
					it "it request to recieve a good json" do
						begin
							output(method, badfile)
						rescue Exception => e
							expect(e.to_s).to eq(abort_msg)
						end
					end
				end
		end

		describe ".check_format" do
				let(:method) {:check_format}
				let(:valid_duns){Factory.build_users_json(user_array, [{"valid_format":true}, {"valid_format":true}])+"\n"}
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "verifies that the duns number is formatted " do
							piped_file
							expect(output(method, goodfile)).to eq(valid_duns)
					end
				end

				context "given an -i flagged input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "verifies that the duns number is formatted " do
							expect(output(method, goodfile)).to eq(valid_duns)
					end
				end
				context "given flagged bad json that doesn't include duns keys" do
					it "it request to recieve a good json" do
							begin
								output(method, badfile)
							rescue Exception => e
								expect(e.to_s).to eq(abort_msg)
							end
					end
				end

		end

		describe ".format" do
			let(:method) {:format}
			let(:format_duns){Factory.build_users_json(user_array, [{"formatted_duns":"0800374780000"}, {"formatted_duns":"0800314780000"}])+"\n"}
				context "given piped input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "formats duns numbers in a json " do
							piped_file
							expect(output(method, goodfile)).to eq(format_duns)
					end
				end

				context "given an -i flagged input.json that includes {'users:[{'duns: duns_num'}]'}" do
					it "formats duns numbers in a json " do
							expect(output(method, goodfile)).to eq(format_duns)
					end
				end

				context "given flagged bad json that doesn't include duns keys" do
					it "it request to recieve a good json" do
						begin
							output(method, badfile)
						rescue Exception => e
							expect(e.to_s).to eq(abort_msg)
						end
					end
				end
		end

end
