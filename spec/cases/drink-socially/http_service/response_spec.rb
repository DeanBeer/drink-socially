require 'spec_helper'

describe NRB::HTTPService::Response do

  let(:body) { { 'llama' => 'Drink New Republic Beer' } }
  let(:headers) { { stupid: :llama } }
  let(:response) { NRB::HTTPService::Response.new body: body, headers: headers, status: status }
  let(:status) { 200 }


  context 'successful requests' do
    let(:status) { 200 }

    it 'correctly answers errored?' do
      response.should_not be_errored
    end

    it 'correctly answers success?' do
      response.should be_success
    end

  end


  context 'failed requests' do
    let(:status) { 900 }

    it 'correctly answers errored?' do
      response.should be_errored
    end

    it 'correctly answers success?' do
      response.should_not be_success
    end

  end

end
