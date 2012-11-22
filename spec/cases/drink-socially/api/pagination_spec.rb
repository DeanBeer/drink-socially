require 'spec_helper'
describe NRB::Untappd::API::Pagination do

  let(:body) { { response: { pagination: pagination_hash } } }
  let(:headers) { {} }
  let(:max_id) { 16546450 }
  let(:next_url) { "http://api.untappd.com/v4/brewery/checkins/8767?min_id=16546450" }
  let(:pagination) { NRB::Untappd::API::Pagination.from_response(response) }
  let(:pagination_hash) { {
                            since_url: since_url,
                            next_url: next_url,
                            max_id: max_id
                        } }
  let(:response) { NRB::Untappd::API::Response.new( status, body, headers ) }
  let(:since_url) { "http://api.untappd.com/v4/brewery/checkins/8767?min_id=16546450" }
  let(:status) { 200 }


  context 'from a response without pagination' do

    let(:body) { { response: { } } }

    it 'gives you nil' do
      pagination.should be_nil
    end
  end


  it 'gives you a pagination object' do
    pagination.should be_a(NRB::Untappd::API::Pagination)
  end


  it 'has the correct next_id' do
    pagination.next_id.should eq (max_id + 1)
  end


  it 'has the correct prev_id' do
    pagination.prev_id.should eq (max_id - 1)
  end

end
