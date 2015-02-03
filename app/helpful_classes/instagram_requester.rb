class InstagramRequester

  def self.photos_by_user_location(lat, long)
    location_array = Location.by_location(lat, long)
    photo_hash = {}
    location_array.each {|loc| photo_hash.merge!(photos_by_location(loc)) }
    photo_hash
  end

  def self.photos_by_location(location)
    find_locations(location)
    location_codes = location.insta_codes.collect {|insta_code| insta_code.code}
    photos = location_codes.collect { |code| photos_by_instacode(code) }
    hash = {}
    photos.flatten.each do |url|
      hash[url] = location.id
    end
    hash
  end

  def self.find_locations(location)
    if location.insta_codes.empty?
      Instagram.location_search(location.lat, location.long, "500").each do |result|
        if result.name.include?(location.name)
          InstaCode.create(code: result.id, location_id: location.id)
        end
      end
    end
  end

  def self.photos_by_instacode(instacode)
    Instagram.location_recent_media(instacode).collect do |mash|
      mash.images.standard_resolution.url
    end
  end
end
=begin

EXAMPLE OF WHAT location_recent_media returns
[#<Hashie::Mash
  attribution=nil
  caption=#<Hashie::Mash
          created_time="1352478293"
          from=#<Hashie::Mash
                  full_name="zoanostrildog"
                  id="43335411"
                  profile_picture=
                  "https://instagramimages-a.akamaihd.net/profiles/profile_43335411_75sq_1338910974.jpg"
                  username="zoanostrildog">
          id="320934132501082550" text="#wolfdog #comfortdiva #garage #206">
  comments=#<Hashie::Mash
            count=0
            data=[]>
  created_time="1352478293"
  filter="Amaro"
  id="320933646616130521_43335411"
  images=#<Hashie::Mash
          low_resolution=#<Hashie::Mash
                            height=306
                            url=  "http://scontent-b.cdninstagram.com/hphotos-xfp1/outbound-distilleryimage1/t0.0-17/OBPTH/fe24232c2a8911e2bf2722000a1fbc66_6.jpg"
                            width=306>

          standard_resolution=#<Hashie::Mash
                                height=612
                                url=  "http://scontent-b.cdninstagram.com/hphotos-xfp1/outbound-distilleryimage1/t0.0-17/OBPTH/fe24232c2a8911e2bf2722000a1fbc66_7.jpg"
                                width=612>
          thumbnail=#<Hashie::Mash
                        height=150
                        url=  "http://scontent-b.cdninstagram.com/hphotos-xfp1/outbound-distilleryimage1/t0.0-17/OBPTH/fe24232c2a8911e2bf2722000a1fbc66_5.jpg"
                        width=150>
  >
  likes=#<Hashie::Mash
          count=1
          data=[#<Hashie::Mash
                  full_name="Kristian \"Rig\" Garrard"
                  id="1930616"
                  profile_picture=
                  "https://instagramimages-a.akamaihd.net/profiles/profile_1930616_75sq_1392270102.jpg"
                  username="kkrriissttiiaann">]
          >
  link="http://instagram.com/p/R0L3ODBnPZ/"
  location=#<Hashie::Mash
              id=45420375
              latitude=47.60882243
              longitude=-122.33375453
              name="IBM parking garage">
  tags=["wolfdog", "206", "comfortdiva", "garage"]
  type="image"
  user=#<Hashie::Mash
          bio=""
          full_name="zoanostrildog"
          id="43335411"
          profile_picture=
           "https://instagramimages-a.akamaihd.net/profiles/profile_43335411_75sq_1338910974.jpg"
          username="zoanostrildog" website="">
  users_in_photo=[]
>]
=end
