require 'spec_helper'

describe NRB::HTTPService do

  describe 'class methods' do

    it 'has a default middleware' do
      NRB::HTTPService.default_middleware.should be_a(Proc)
    end

    it 'has a default response class' do
      NRB::HTTPService.default_response_class.should eq NRB::HTTPService::Response
    end

  end

  context 'making requests' do

    let(:args)       { {} }
    let(:body)       { {} }
    let(:connection) { stub "here's a beer", verb => connection_response }
    let(:connection_response)   { double "skal", body: body, headers: headers, status: status }
    let(:headers)    { {} }
    let(:path)       { '/' }
    let(:response)   { NRB::HTTPService.new(path: path, verb: verb).make_request }
    let(:status)     { 200 }
    let(:verb)       { :get }

    context 'successful requests' do

      before do
        Faraday.stub(:new).and_return(connection)
      end
      it 'returns a Response object' do
        response.should be_a(NRB::HTTPService.default_response_class)
      end

      it 'resuces with an successful Response object' do
        response.should be_success
      end

    end


    context 'parse errors' do

      let(:error) { Faraday::Error::ParsingError.new(message) }
      let(:message) { "!Blark!" }

      before do
        Faraday.stub(:new).and_raise(error)
      end

      it 'resuces with a Response object' do
        response.should be_a(NRB::HTTPService.default_response_class)
      end

      it 'resuces with an errored Response object' do
        response.should be_errored
      end

      it 'gives you the error' do
        response.body[:error].should eq message
      end

    end

  end

end
