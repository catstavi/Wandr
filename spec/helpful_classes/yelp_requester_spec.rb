require 'rails_helper'

describe YelpRequester do
  describe '#self.request'
    context "there is no data passed" do
      xit "raises an error that explains no data" do
        expect { YelpRequester.request(nil, nil) }.to raise_error
      end
    end

    context "there is legit data passed" do
      it "returns a BurstStruct::Burst Object" do
        response = VCR.use_cassette 'yelp_response' do
          YelpRequester.request(47.608847245574, -122.333854660392)
        end
        expect(response).to be_a BurstStruct::Burst
      end
    end
  end


    # describe 'sorted_google_response' do
    #   it 'should return an array' do
    #     response = VCR.use_cassette 'google_places' do
    #       tacos.sorted_google_response
    #     end
    #
    #     expect(response).to be_an_instance_of Array
    #   end
    # end


  # spec/model/your_model_spec.rb
  # describe YourModel do
  #   describe '#call_api&quot; do
  #      it &quot;gets a response from an api&quot; do
  #        VCR.use_cassette 'model/api_response' do
  #           response = call_api(api_url)
  #           response.first.should == &quot;hello world&quot;
  #        end
  #      end
  #   end
  # end
