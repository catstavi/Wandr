class InstagramRequester


  def self.check_for_updates(location)
    if location.photos_updated_at < Time.now - 1.day
      photos_by_location(location)
    elsif location.insta_codes_updated_at < Time.now - 2.weeks
      find_insta_codes(location)
    end
  end

  def self.save_photos_by_user_location(lat, long)
    location_array = Location.by_location(lat, long)
    location_array.each { |loc| photos_by_location(loc) }
  end

  def self.photos_by_location(location)
    find_insta_codes(location)
    location_codes = location.insta_codes.collect {|insta_code| insta_code.code}
    photos = location_codes.collect { |code| photos_by_instacode(code) }
    photos.flatten.each do |url|
      Photo.create(url: url, location_id: location.id)
    end
    location.update(photos_updated_at: Time.now)
  end

  # queries instagram to find new location codes if the given location has none
  # or if it hasn't been updated for 2 weeks
  def self.find_insta_codes(location)
    if location.insta_codes.empty? || location.updated_at < Time.now - 2.weeks
      insta_size = InstaCode.count
      Instagram.location_search(location.lat, location.long, "500").each do |result|
        if result.name.include?(location.name)
          InstaCode.create(code: result.id, location_id: location.id)
        end
      end
      location.update(insta_code_updated_at: Time.now)
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
