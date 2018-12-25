module Slugcatcher
  class Lookup
    attr_reader :cuisines, :categories, :location

    def initialize(models, slugs)
      @models = models
      @slugs = slugs.split('/')
      @cuisines = []
      @categories = []
      @location = nil
    end

    def execute
      @slugs.each do |slug|
        lookup_slug(slug)
      end
      no_match? ? nil : { cuisines: cuisines, categories: categories, location: @location}
    end

    private

    def dictionary
      @dictionary ||= Slugcatcher::Dictionary.new(@models)
    end

    def terms
      dictionary.ordered_terms
    end

    def slug_matches_term?(term, slug)
      !slug.match(/-?#{term}-?/).nil?
    end

    def remove_term_from_slug(term, slug)
      slug.gsub!(/-?#{term}-?/, '')
    end

    def lookup_slug(slug)
      terms.each do |term|
        if slug_matches_term?(term, slug)
          remove_term_from_slug(term, slug)
          if dictionary.location?(term)
            location = dictionary.text(term)
          elsif dictionary.cuisine?(term)
            cuisines << dictionary.text(term)
          elsif dictionary.category?(term)
            categories << dictionary.text(term)
          end
        end
        break if slug.empty?
      end
    end

    def no_match?
      cuisines.empty? && categories.empty? && location.nil?
    end
  end
end
