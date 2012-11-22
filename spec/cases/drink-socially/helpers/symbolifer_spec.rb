require 'spec_helper'

describe :nrb_symbolify do

  describe Array do

    context 'an array of "simple" objects' do
      let(:array) { [ "string", :symbol, nil ] }
      it "doesn't change" do
        array.nrb_symbolify.should eq array
      end
    end

    context 'an array with hashes' do
      let(:array) { [ { key: :value }, { "key" => :value } ] }
      let(:test_subject) { array.clone.nrb_symbolify }
      it 'symbolifys the hashes' do
        test_subject.nrb_symbolify
        test_subject.each_with_index do |e,i|
          e.should eq array[i].nrb_symbolify
        end
      end
    end

  end


  describe Hash do

    it 'returns a hash' do
      {}.nrb_symbolify.should be_a(Hash)
    end

    context 'with all symbol keys' do
      let(:hash) { { key: :value } }
      it "doesn't change" do
        hash.nrb_symbolify.should eq hash
      end
    end

    context 'with string keys' do
      let(:hash) { { "key" => :value } }
      it 'makes the keys into symbols' do
        hash.nrb_symbolify.keys.each { |k| k.should be_a(Symbol) }
      end
    end

    context 'with the same string & symbol keys' do
      let(:hash) { { key: :val1, "key" => :val1 } }
      it 'explodes' do
        expect { hash.nrb_symbolify }.to raise_error(NRB::KeyConflict)
      end
    end

    context 'with a nested hash' do
      let(:hash) { { key => { "key" => :val } } }
      let(:key) { "key" }
      it 'symbolifies the nested hash' do
        result = hash.nrb_symbolify
        result[key.to_sym].keys.each { |k| k.should be_a(Symbol) }
      end
    end

  end

  describe Object do
    it 'responds to nrb_symbolify' do
      subject.should respond_to(:nrb_symbolify)
    end
    it 'returns itself' do
      subject.nrb_symbolify.should eq subject
    end
  end

end
