require 'spec_helper'

describe NRB::HTTPService do

  it 'has a default middleware' do
    NRB::HTTPService.default_middleware.should be_a(Proc)
  end

  context 'making requests' do

    let(:args)       { {} }
    let(:body)       { {} }
    let(:connection) { stub "here's a beer", verb => connection_response }
    let(:connection_response)   { double "skal", body: body, headers: headers, status: status }
    let(:headers)    { {} }
    let(:path)       { '/' }
    let(:response)   { NRB::HTTPService.make_request(verb, path) }
    let(:status)     { 200 }
    let(:verb)       { :get }

#    before do
#      connection_response.should_receive(:body).and_return(body)
#      connection_response.should_receive(:headers).and_return(headers)
#      connection_response.should_receive(:status).and_return(status)
#      connection.should_receive(verb).with(path,args).and_return(connection_response)
#    end

    context 'successful requests' do

      before do
        Faraday.stub(:new).and_return(connection)
      end
      it 'returns a Response object' do
        response.should be_a(NRB::HTTPService::Response)
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
        response.should be_a(NRB::HTTPService::Response)
      end

      it 'resuces with an errored Response object' do
        response.should be_errored
      end

      it 'gives you the error' do
        response.body['error'].should eq message
      end

    end

  end

end
