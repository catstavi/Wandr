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
          stub_request(:get, "http://api.yelp.com/v2/search?category_filter=aquariums,basketballcourts,beaches,bowling,boating,climbing,gokarts,gun_ranges,hiking,horsebackriding,hot_air_balloons,lakes,lasertag,mini_golf,paintball,parks,recreation,skatingrinks,skydiving,swimmingpools,tennis,zoos,arcades,galleries,gardens,movietheaters,jazzandblues,museums,musicvenues,observatories,opera,theater,planetarium,psychic_astrology,spas,massage,farmersmarket,tea,tours,poolhalls,karaoke,libraries,landmarks,bookstores,fleamarkets,vintage,antiques&ll=47.618517,-122.335852,,,&sort=1").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'OAuth oauth_consumer_key="CSL-X8Q5F6gYNeGO38crvg", oauth_nonce="5dbe3314bcff24b1a258374bf449fea2", oauth_signature="tDUh7VGDRo%2B6j7NMnSN4oIw2RCQ%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1423507414", oauth_token="qEpO3668P19wjIB-1uzHIxGqkdd-7wwC", oauth_version="1.0"', 'User-Agent'=>'Faraday v0.9.1'})
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
