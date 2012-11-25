require 'spec_helper'
require 'yaml'

describe NRB::Untappd::Config do

  shared_examples_for 'a config object' do

    it 'defines accessors from a hash' do
      config_hash.keys.each do |key|
        config.should respond_to(key)
      end
    end


    it 'uses values from its data hash' do
      config_hash.each do |k,v|
        config.send(k).should eq v
      end
    end


    it 'responds to :[]' do
      config.should respond_to(:[])
    end


    it 'responds to :keys' do
      config.should respond_to(:keys)
    end


    it 'uses keys from its data hash' do
      config.keys.should eq config.data.keys
    end


    it 'delegates [] to its data hash' do
      config_hash.each do |k,v|
        config[k].should eq v
      end
    end

  end


  context 'loading from a YAML file' do
    let(:config_hash) { YAML.load_file filename }
    let(:config) { NRB::Untappd::Config.new filename: filename }
    let(:filename) { NRB::Untappd.config_file_path '../spec/support/config.yml' }
    it_behaves_like 'a config object'
  end


  context 'loading from a stream' do
    let(:config_hash) { { this: :is, a: :stream } }
    let(:string) { config_hash.to_yaml }
    let(:string_io) { StringIO.new(string) }
    let(:config) { NRB::Untappd::Config.new stream: string_io }
    it_behaves_like 'a config object'
  end


  context 'with no stream or filename argument' do
    let(:config) { NRB::Untappd::Config.new Hash.new }
    it 'explodes' do
      expect { config }.to raise_error(NRB::Untappd::Config::NoConfig)
    end
  end


  context 'loaders' do

    before :all do
      Loader = Struct.new(:data) { def load_stream(*args); data; end }
    end

    let(:config_array) { [ config_hash ] }
    let(:config_hash) { { change: :the, stream: :loader } }
    let(:loader) { Loader.new config_array }
    let(:config) { NRB::Untappd::Config.new stream_loader: loader, stream: {} }

    it 'allows you to change the config loader' do
      config.should be_a(NRB::Untappd::Config)
    end

    it_behaves_like 'a config object'

  end

end
