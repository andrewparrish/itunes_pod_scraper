require "itunes_pod_scraper/version"
require 'itunes_pod_scraper/scraper'

module ItunesPodScraper
  BASE_URL = "https://itunes.apple.com/us/genre/podcasts-arts/id1301?mt=2"
  CATEGORY_URL = "https://itunes.apple.com/us/genre/podcasts/id26?mt=2"

  def self.get_podcast_categories
    Scraper.new.get_top_level_categories
  end
end
