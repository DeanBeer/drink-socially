require 'spec_helper'

describe NRB::Untappd::API::URLTokenizer do

  let(:map)   { { token => :llama } }
  let(:result) { tokenizer.tr }
  let(:token) { :blark }
  let(:tokenizer) { NRB::Untappd::API::URLTokenizer.new map: map, string: string }


  it 'raises ArgumentError with no map' do
    expect { NRB::Untappd::API::URLTokenizer.new string: "" }.to raise_error(ArgumentError)
  end


  it 'raises ArgumentError with no string' do
    expect { NRB::Untappd::API::URLTokenizer.new map: map }.to raise_error(ArgumentError)
  end


  context 'a non-tokenized string' do
    let(:string) { "some/url#{token}#its_cool" }
    it 'leaves the string alone' do
      result.should eq string
    end
  end


  context 'a tokenized string' do
    let(:string) { "some/:#{token}:/url" }
    it 'changes a string with a single token' do
      result.should eq "some/#{map[token]}/url"
    end

    it 'changes multiple tokens' do
      t = NRB::Untappd::API::URLTokenizer.new map: { token1: :llama, token2: :beer }, string: "/some/:token2:/path/:token1:"
      t.tr.should eq "/some/beer/path/llama"
    end
  end

end
