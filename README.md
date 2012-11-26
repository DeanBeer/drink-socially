# drink-socially

[![Build Status](https://secure.travis-ci.org/NewRepublicBrewing/drink-socially.png)](http://travis-ci.org/NewRepublicBrewing/drink-socially)
[![Dependency Status](https://gemnasium.com/NewRepublicBrewing/drink-socially.png)](https://gemnasium.com/NewRepublicBrewing/drink-socially)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/NewRepublicBrewing/drink-socially)

A gem for interfacing with the Untappd API

## Requirements

Ruby 1.9

## Usage

### Acting as a person

```ruby
require 'drink-socially'

# Per-user access token taken from OAuth
brundage = NRB::Untappd::API.new access_token: '7A23A8BEER81D2580E&CEFC405C60693AC476AA'

new_republic = brundage.brewery_info brewery_id: 8767
=> #<Hashie::Mash beer_count=13 beer_list=....

new_republic.attributes.sort
 => [:beer_count, :beer_list, :brewery_description, :brewery_id, :brewery_in_production, :brewery_label, :brewery_name, :brewery_type, :checkins, :claimed_status, :contact, :country_name, :location, :media, :rating, :stats] 


new_republic.brewery_name
 => "New Republic Brewing Company" 

```

### Acting as an app

```ruby
# Get your id & secret from http://untappd.com/api/dashboard
new_republic_app = NRB::Untappd::API.new client_id: '645c10bc59f30e34d6fd265cfdeb75e', client_secret: '9ffe686c814207df12f9b0e0bc0cdab'
```

## Methods

### NRB::Untappd::API

`new` takes a user access token or a application id and secret. Once you have an instance of the API you can make calls on behalf of the user or application.

The Untappd api enforces a rate limit per token.  After the first call you can ask your object the current limit with `rate_limit`.

```
brundage.rate_limit
 => @rate_limit= #<NRB::Untappd::API::RateLimit:0x930af6c @limit="100", @remaining="99">>
```

API calls return an `NRB::Untappd::API::Object`, which is mostly a Hashie::Mash.

Documentation for the API calls are detailed [in the wiki](drink-socially/wiki/api_calls).  Also have a look at the [Untappd v4 API documentation](http://untappd.com/api/docs/v4) for details.

### NRB::Untappd::API::Object

Responses from the API are marshalled into `NRB::Untappd::API::Object` instances.
