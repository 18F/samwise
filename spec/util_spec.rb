require 'spec_helper'
require 'samwise'

describe Samwise::Util do
  let(:eight_duns) { '88371771' }
  let(:nine_duns)  { '883717717' }

  it "should format an 8 digit DUNS into a 13 digit DUNS" do
    formatted_duns = Samwise::Util.format_duns(duns: eight_duns)

    expect(formatted_duns.length).to eq(13)
  end

  it "should format a 9 digit DUNS into a 13 digit DUNS" do
    formatted_duns = Samwise::Util.format_duns(duns: nine_duns)

    expect(formatted_duns.length).to eq(13)
  end
end
