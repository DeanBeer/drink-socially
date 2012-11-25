require 'spec_helper'

describe NRB::Untappd do

  it 'has a http_service accessor' do
    subject.should respond_to(:http_service=)
  end


  it 'has a default http_service' do
    subject.http_service.should == NRB::HTTPService
  end


  let(:filename) { NRB::Untappd.config_file_path '../spec/support/config.yml' }

  it 'loads a config resource' do
    subject.load_config(filename: filename).should be_a(NRB::Untappd::Config)
  end 


  describe 'config file location' do

    let(:absolute_path) { '/llama' }
    let(:basedir) { File.expand_path( File.join( File.dirname(__FILE__), '..', '..', 'config' ) ) }
    let(:relative_path) { 'llama' }
    let(:expected_from_relative) { File.join( basedir, relative_path ) }


    it 'returns an absolute path' do
      subject.config_file_path(absolute_path).should eq absolute_path
    end


    it 'finds the config directory' do
      subject.config_file_path(relative_path).should eq expected_from_relative
    end

  end

end
