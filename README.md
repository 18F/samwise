# tarly

* [Homepage](https://rubygems.org/gems/tarly)
* [Documentation](http://rubydoc.info/gems/tarly/frames)

[![Build Status](https://travis-ci.org/18F/tarly.svg)](https://travis-ci.org/18F/tarly)
[![Code Climate](https://codeclimate.com/github/18F/tarly/badges/gpa.svg)](https://codeclimate.com/github/18F/tarly)
[![Test Coverage](https://codeclimate.com/github/18F/tarly/badges/coverage.svg)](https://codeclimate.com/github/18F/tarly/coverage)
[![Issue Count](https://codeclimate.com/github/18F/tarly/badges/issue_count.svg)](https://codeclimate.com/github/18F/tarly)

## Description

Ruby access to the SAM.gov API.

## Usage

To get started, you'll need an API key from https://api.data.gov.

### Configuration

Set the api.data.gov API key as the environment variable `DATA_GOV_API_KEY` or pass the key as an argument:

```ruby
require 'tarly'

client = Tarly::Sam.new(api_key: 'my key ...')

# if you set the DATA_GOV_API_KEY env var, just use:
client = Tarly::Sam.new
```

### Verify DUNS number

```ruby
client.duns_is_valid?(duns: '080037478')
#=> true
```

### Get DUNS info

```ruby
client.get_duns_info(duns: '080037478')
#=>
{
    "sam_data" => {
        "registration" => {
            "govtBusinessPoc" => {
                "lastName" => "SUDOL", "address" => {
                    "Line1" => "4301 N HENDERSON RD APT 408", "Zip" => "22203", "Country" => "USA", "City" => "Arlington", "stateorProvince" => "VA"
                }, "email" => "BRENDANSUDOL@GMAIL.COM", "usPhone" => "5404218332", "firstName" => "BRENDAN"
            }, "dunsPlus4" => "0000", "activationDate" => "2015-10-30 11:42:30.0", "fiscalYearEndCloseDate" => "12/31", "businessTypes" => ["VW", "2X", "27"], "registrationDate" => "2015-10-28 00:00:00.0", "certificationsURL" => {
                "pdfUrl" => "https://www.sam.gov/SAMPortal/filedownload?reportType=1&orgId=%2BFCe4Gq91w3LPzmIapO9KekwldCbu7D2ee%2FlxnUkqFvrQwe3OD%2FJSpI%2FuXW0rrpz&pitId=clfEJcL40D6baXhmKE8hVFZPHUDQegjQvNgn4YGfaL%2Fzh6O%2B%2FUJYaSJJ0dKFPFhm&requestId=Xzq5jdsGDkiXPF4"
            }, "hasDelinquentFederalDebt" => false, "duns" => "080037478", "cage" => "7H1Y7", "hasKnownExclusion" => false, "publicDisplay" => true, "expirationDate" => "2016-10-27 10:53:02.0", "status" => "ACTIVE", "corporateStructureCode" => "2J", "stateOfIncorporation" => "VA", "corporateStructureName" => "Sole Proprietorship", "legalBusinessName" => "Sudol, Brendan", "congressionalDistrict" => "VA 08", "businessStartDate" => "2015-10-28", "statusMessage" => "Active", "lastUpdateDate" => "2015-11-02 17:36:23.0", "submissionDate" => "2015-10-28 10:53:02.0", "samAddress" => {
                "Zip4" => "2511", "Line1" => "4301 N Henderson Rd Apt 408", "Zip" => "22203", "Country" => "USA", "City" => "Arlington", "stateorProvince" => "VA"
            }, "naics" => [{
                "isPrimary" => false, "naicsCode" => "518210", "naicsName" => "DATA PROCESSING, HOSTING, AND RELATED SERVICES"
            }, {
                "isPrimary" => true, "naicsCode" => "541511", "naicsName" => "CUSTOM COMPUTER PROGRAMMING SERVICES"
            }], "creditCardUsage" => true, "countryOfIncorporation" => "USA", "electronicBusinessPoc" => {
                "lastName" => "SUDOL", "address" => {
                    "Line1" => "4301 N HENDERSON RD APT 408", "Zip" => "22203", "Country" => "USA", "City" => "Arlington", "stateorProvince" => "VA"
                }, "email" => "BRENDANSUDOL@GMAIL.COM", "usPhone" => "5404218332", "firstName" => "BRENDAN"
            }, "mailingAddress" => {
                "Zip4" => "2511", "Line1" => "4301 N Henderson Rd Apt 408", "Zip" => "22203", "Country" => "USA", "City" => "Arlington", "stateorProvince" => "VA"
            }, "purposeOfRegistration" => "ALL_AWARDS"
        }
    }
}
```

`duns` can be an 8, 9, or 13 digit number:

- If it is 8 digits, `0` is prepended, and `0000` is added to the end.
- If it is 9 digits, `0000` is added to the end.
- If it is 13 digits, the number is unchanged.

## Install

In your Gemfile:

```ruby
gem 'tarly', github: '18f/tarly'
```

### Coming Soon

```
$ gem install tarly
```

## Public Domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
