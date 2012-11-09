require 'spec_helper'

describe NRB::Untappd do

  it 'has a http_service accessor' do
    subject.should respond_to(:http_service=)
  end


  it 'has a default http_service' do
    subject.http_service.should == NRB::HTTPService
  end

end
