require 'spec_helper'

describe NRB::Untappd::API do

  it 'has a version' do
    NRB::Untappd::API.should respond_to :api_version
  end

  it 'has a server' do
    NRB::Untappd::API.should respond_to :server
  end

end
