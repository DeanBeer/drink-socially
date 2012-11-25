require 'spec_helper'
describe NRB::Untappd::API::Object do

  let(:body) { { llama: { llama: { llama: { llamas: :all_the_way_down,
                                            dude: :sweet 
                                          } } } } }
  let(:headers) { { stupid: :llama } }
  let(:response) { NRB::Untappd::API::Object.new body: body, headers: headers, status: status }
  let(:status) { 200 }

  it 'has a pagination object' do
    response.should respond_to(:pagination)
  end


  context 'extracting an object from the body' do

    let(:path) { [ :llama, :llama, :llama ] }
    let(:response) { NRB::Untappd::API::Object.new body: body, headers: headers, status: status, results_path: path }
    let(:target) { response.body[:llama][:llama][:llama] }

     it 'assingns the extraction to @results' do
      response.results.should eq target
    end

    it 'updates @attributes with the hash keys' do
      response.attributes.collect(&:to_sym).sort.should eq target.keys.collect(&:to_sym).sort
    end


    it 'defines a methods on response for each hash key' do
      target.keys.each { |m| response.should respond_to(m) }
    end

  end


  context 'errored responses' do

    let(:error_detail) { "This Venue ID is invalid" }
    let(:error_type) { "invalid_param" }
    let(:status) { 500 }

    context 'v4' do

      let(:body) { { meta: { code: 500,
                             error_detail: error_detail,
                             error_type: error_type,
                             response_time: { time: 0.089,
                                              measure: "seconds" }
                           },
                     response: [] } }

      it 'creates an errored response' do
        response.should be_errored
      end

      it 'has an error message' do
        response.error_message.should_not be_nil
      end

      it 'tells you the error detail' do
        response.error_message.should match /#{error_detail}/
      end

      it 'tells you the error type' do
        response.error_message.should match /#{error_type}/
      end

    end


    context 'legacy' do

      let(:body) { { error: error_detail } }

      it 'has an error message' do
        response.error_message.should_not be_nil
      end

      it 'tells you the error detail' do
        response.error_message.should match /#{error_detail}/
      end

    end


    context 'unrecognized' do
      let(:body) { { } }

      it 'has an error message' do
        response.error_message.should_not be_nil
      end

    end


    context 'successful requests' do

      let(:status) { 200 }

      it 'should not have an error_message' do
        response.error_message.should be_nil
      end

    end

  end



end
