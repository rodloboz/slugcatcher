module Slugcatcher
  class Dictionary
    attr_reader :names

    def initialize(models)
      @names = []
      models.each do |model|
        name = model[0].name.underscore
        @names << name
        Dictionary.define_dictionary_methods(name, model[1])
      end
    end

    def self.define_dictionary_methods(name, lookup)
      dictionary_name = "#{name.pluralize}_dictionary"

      class_eval %{
        def #{dictionary_name}
          @#{dictionary_name} ||= build_dictionary(:#{name}, :#{lookup})
        end

        def #{name}?(term)
          #{dictionary_name}.key?(term)
        end
      }
    end

    def ordered_terms
      slug_dictionary.keys.sort_by { |slug| slug.length }.reverse!
    end

    def text(term)
      slug_dictionary[term][:text]
    end

    def id(term)
      slug_dictionary[term][:id]
    end

    def term(id)
      slug_dictionary.each { |k, v| return v[:text] if v[:id] == id }
    end

    private

    def dictionaries
      @dictionaries ||= methods.grep /^.*_dictionary/
    end

    # merge hash dictionaries into single hash
    def slug_dictionary
      dictionaries.map { |d| send(d) }.reduce Hash.new, :merge
    end

    def build_dictionary(name, lookup)
      dictionary = {}
      klass = name.to_s.camelize.constantize
      klass.pluck(:id, lookup.to_sym).each do |id, lookup|
        key = lookup.parameterize
        dictionary[key] = {id: id, text: lookup }
      end
      dictionary
    end
  end
end
