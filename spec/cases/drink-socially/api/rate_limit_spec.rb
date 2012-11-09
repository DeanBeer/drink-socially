require 'spec_helper'
describe NRB::Untappd::API::RateLimit do

  let(:headers) { { 'x-ratelimit-limit' => 5, 'x-ratelimit-remaining' => 4 } }
  let(:rate_limit) { NRB::Untappd::API::RateLimit.new headers }

  it 'correctly assigns limit' do
    rate_limit.limit.should eq headers['x-ratelimit-limit']
  end

  it 'correctly assigns remaining' do
    rate_limit.remaining.should eq headers['x-ratelimit-remaining']
  end

end
