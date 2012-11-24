require 'spec_helper'

describe NRB::Untappd::API do

  context 'class methods' do

    it 'has a version' do
      NRB::Untappd::API.should respond_to :api_version
    end

    it 'has a server' do
      NRB::Untappd::API.should respond_to :server
    end

    describe 'default helper classes' do

      it 'uses Credential' do
        NRB::Untappd::API.default_credential_class.should eq NRB::Untappd::API::Credential
      end

      it 'uses RateLimit' do
        NRB::Untappd::API.default_rate_limit_class.should eq NRB::Untappd::API::RateLimit
      end

      it 'uses Object' do
        NRB::Untappd::API.default_response_class.should eq NRB::Untappd::API::Object
      end

    end

  end


  let(:api) { NRB::Untappd::API.new options }
  let(:options) { { access_token: 'NewRepublicBrewing' } }

  it 'has a credential accessor' do
    api.should respond_to(:credential)
  end


  it 'has a credential object' do
    api.credential.should be_a(NRB::Untappd::API::Credential)
  end

end
