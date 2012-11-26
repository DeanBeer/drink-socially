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


  context 'using an endpoint config' do

    let(:api) { NRB::Untappd::API.new options }
    let(:endpoints) { { endpoint1: { }, endpoint2: { } } }
    let(:options) { { access_token: 'NewRepublicBrewing', endpoints: endpoints } }


    it 'defines methods based on the top level of the config hash' do
      endpoints.keys.each do |meth|
        api.should respond_to(meth)
      end
    end


    context 'with method aliases' do
      let(:endpoints) { { endpoint1: { method_aliases: method_aliases } } }
      let(:method_aliases) { [ :an_alias ] }
      it 'defines methods for the aliases' do
        method_aliases.each do |meth|
           api.should respond_to(meth)
         end
      end
    end


    context 'with required arguments' do
      let(:endpoints) { { method_name => { required_args: [:llama] } } }
      let(:invalid_args) { { } }
      let(:method_name) { :endpoint1 }
      let(:valid_args) { { llama: :blark } }
      it 'explodes without the required args' do
        expect { api.send method_name, invalid_args }.to raise_error(ArgumentError)
      end
    end
  end

end
