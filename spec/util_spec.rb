require 'spec_helper'
require 'samwise'

describe Samwise::Util do
  let(:seven_duns)    { '8837177' }
  let(:eight_duns)    { '88371771' }
  let(:nine_duns)     { '883717717' }
  let(:thirteen_duns) { '0223841150000' }
  let(:hyphen_duns)   { '08-011-5718' }
  let(:letters_duns)  { 'abc12345678'}
  let(:bad_dunses) do
    [
      '1234567890',
      '12345678901',
      '123456789011',
      '1',
      '',
      '--',
      '12345678901234567890'
    ]
  end

  context '#duns_is_properly_formatted?' do
    it 'should return true when the DUNS is 13 digits (not counting hyphens)' do
      is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: thirteen_duns)

      expect(is_formatted).to be(true)
    end

    it 'should return true when the DUNS is 9 digits (not counting hyphens)' do
      is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: nine_duns)

      expect(is_formatted).to be(true)
    end

    it 'should return true when the DUNS is 8 digits (not counting hyphens)' do
      is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: eight_duns)

      expect(is_formatted).to be(true)
    end

    it 'should return true when the DUNS is 7 digits (not counting hyphens)' do
      is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: seven_duns)

      expect(is_formatted).to be(true)
    end

    it 'should return false when the DUNS is not 8, 9, or 13 digits (not counting hyphens)' do
      bad_dunses.each do |bad_duns|
        is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: bad_duns)

        expect(is_formatted).to be(false)
      end
    end

    it 'should return false when the DUNS contains letters' do
      is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: letters_duns)

      expect(is_formatted).to be(false)
    end

    it 'should return false when the duns number is nil' do
      is_formatted = Samwise::Util.duns_is_properly_formatted?(duns: nil)

      expect(is_formatted).to be(false)
    end
  end

  context '#format_duns' do
    it 'should not suffer from mutability side effects' do
      duns_copy = hyphen_duns.dup
      Samwise::Util.format_duns(duns: hyphen_duns)

      expect(hyphen_duns).to eq(duns_copy)
    end

    it 'should format an 7 digit DUNS into a 13 digit DUNS' do
      formatted_duns = Samwise::Util.format_duns(duns: seven_duns)

      expect(formatted_duns.length).to eq(13)
    end

    it 'should format an 8 digit DUNS into a 13 digit DUNS' do
      formatted_duns = Samwise::Util.format_duns(duns: eight_duns)

      expect(formatted_duns.length).to eq(13)
    end

    it 'should format a 9 digit DUNS into a 13 digit DUNS' do
      formatted_duns = Samwise::Util.format_duns(duns: nine_duns)

      expect(formatted_duns.length).to eq(13)
    end

    it 'should remove hyphens from a DUNS number' do
      formatted_duns = Samwise::Util.format_duns(duns: hyphen_duns)

      expect(formatted_duns).to eq('0801157180000')
    end

    it 'should raise a Samwise::Error::InvalidFormat error if the DUNS is invalid' do
      bad_dunses.each do |bad_duns|
        expect do
          Samwise::Util.format_duns(duns: bad_duns)
        end.to raise_error(Samwise::Error::InvalidFormat)
      end
    end
  end
end
