require "mechanize"
require "json"
require "itunes_pod_scraper"
require 'itunes_pod_scraper/category'

module ItunesPodScraper
  class Scraper

    ID_REGEX = /podcast\/\D+\/id(\d+)/
    ID_URL = "https://itunes.apple.com/lookup?id="
    
    def initialize
      @bot = Mechanize.new
      @bot.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def podcast_for_id(pod_id)
      JSON.parse(@bot.get(ID_URL + pod_id).body)['results'][0]
    end

    def get_top_level_categories
      page = @bot.get(CATEGORY_URL)
      page.search("//a[@class='top-level-genre']").map do |a|
        Category.new(a.children[0].text, a.attributes['href'].value)
      end
    end

    def get_all_category_urls
      page = @bot.get(CATEGORY_URL)
      page.links.select { |link| link.href.match(/\/genre\/.+mt=2$/) && link.to_s != "Podcasts" }
    end

    def popular_podcasts_for_category(category_url)
      popular_podcast_ids_for_category(category_url).map do |id|
        podcast_for_id(id)
      end
    end

    def popular_podcast_ids_for_category(category_url)
      process_page(category_url)
    end

    def get_all_podcast_ids
      get_all_category_urls.flat_map { |url| all_ids_for_letters(url.href) }.uniq
    end

    def all_ids_for_letters(category_url)
      ('A'..'Z').to_a.flat_map do |letter|
        process_page("#{category_url}&letter=#{letter}")
      end
    end

    private

    def process_page(url)
      page = @bot.get(url)
      page.links.select { |link| link.href.match(ID_REGEX) }.map { |link| link.href.match(ID_REGEX)[1] }
    end
  end
end
