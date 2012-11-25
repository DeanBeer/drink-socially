require 'spec_helper'

describe Hash do

  let(:original) { { drink: :more, new: :republic, its: :great } }
  let(:expected) { { drink: :more, new: :republic } }

  it 'responds to #slice' do
    subject.should respond_to(:slice)
  end


  it 'slices' do
    original.slice(*expected.keys).should eq expected
  end

end
