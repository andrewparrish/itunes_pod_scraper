require "itunes_pod_scraper/version"
require 'itunes_pod_scraper/scraper'

module ItunesPodScraper
  BASE_URL = "https://itunes.apple.com/us/genre/podcasts-arts/id1301?mt=2"
  CATEGORY_URL = "https://itunes.apple.com/us/genre/podcasts/id26?mt=2"

  def self.get_podcast_categories
    Scraper.new.get_top_level_categories
  end

  def self.popular_podcasts_for_category_url(url)
    Scraper.new.popular_podcasts_for_category(url)
  end

  def self.popular_podcast_ids_for_category_url(url)
    Scraper.new.popular_podcast_ids_for_category(url)
  end

  def self.podcast_for_id(id)
    Scraper.new.podcast_for_id(id)
  end
end
