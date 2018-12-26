module Slugcatcher
  class Lookup
    attr_reader :matches

    def initialize(models, slugs)
      @models = models
      @slugs = slugs.split('/')
      @matches = Hash.new { |h, k| h[k] = [] }
    end

    def execute
      @slugs.each { |slug| lookup_slug(slug) }
      no_match? ? nil : @matches
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
          dictionary.names.each do |name|
            if dictionary.send("#{name}?", term)
              @matches[name.to_sym] << dictionary.text(term)
            end
          end
        end
        break if slug.empty?
      end
    end

    def no_match?
      @matches.empty?
    end
  end
end
