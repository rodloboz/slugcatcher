module Slugcatcher
  class Dictionary
    attr_reader :names

    def initialize(models)
      @names = models.map { |m| m.name.underscore}
      @names.each { |name| Dictionary.define_dictionary_methods(name) }
    end

    def self.define_dictionary_methods(name)
      dictionary_name = "#{name.pluralize}_dictionary"

      class_eval %{
        def #{dictionary_name}
          @#{dictionary_name} ||= build_dictionary(:#{name})
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

    def build_dictionary(name)
      dictionary = {}
      klass = name.to_s.camelize.constantize
      klass.pluck(:id, :name).each do |id, name|
        key = name.parameterize
        dictionary[key] = {id: id, text: name }
      end
      dictionary
    end
  end
end
