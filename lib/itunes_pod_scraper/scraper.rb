require "mechanize"
require "json"
require "itunes_pod_scraper"

module ItunesPodScraper
  class Scraper

    ID_REGEX = /podcast\/\D+\/id(\d+)/
    ID_URL = "https://itunes.apple.com/lookup?id="
    
    def initialize
      @bot = Mechanize.new
      @bot.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def get_all_category_urls
      page = @bot.get(CATEGORY_URL)
      page.links.select { |link| link.href.match(/\/genre\/.+mt=2$/) && link.to_s != "Podcasts" }
    end

    def get_all_podcast_ids
      get_all_category_urls.flat_map do |url|
        ids = all_ids_for_letters(url.href)
        binding.pry
      end
    end

    #def process_category(url)
    #  all_ids_for_letters(url).map do |id|
    #    data = JSON.parse(@bot.get(ID_URL + id).body)
    #    # Podcast.create_from_json(data)
    #    binding.pry
    #  end
    #end

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
