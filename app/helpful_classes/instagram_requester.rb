class InstagramRequester
#refactor names
  def self.find_location(location)
    # results = Instagram.location_search(location.lat, location.long, "500")
    Instagram.location_search(location.lat, location.long, "500").each do |result|
      if result.name == location.name
        return get_photos(result.id)
      end
    end
  end

  def self.get_photos(location_id)
    Instagram.location_recent_media(location_id).each do |locale|
      return locale
      # .images.standard_resolution.url
      # photo.images.standard_resolution.url
    end
  end
end
