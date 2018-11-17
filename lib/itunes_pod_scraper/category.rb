module ItunesPodScraper
  class Category
    attr_reader :name, :url, :parent_category, :popular_podcast_ids

    def initialize(name, url, parent_category = nil)
      @name = name
      @url = url
      @parent_category = parent_category
    end

    def get_popular_podcast_ids
      @popular_podcast_ids = Scraper.new.popular_podcast_ids_for_category(self)
    end
  end
end
