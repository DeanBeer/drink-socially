require 'spec_helper'

describe NRB::Untappd do

  it 'responds to version' do
    NRB::Untappd.should respond_to :version
  end


  it 'gives a version string' do
    NRB::Untappd.version.should be_a String
  end

end
