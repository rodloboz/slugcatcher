module Slugcatcher
  class Dictionary
    def initialize(models)
      @names = models.map { |m| m.name.underscore}
      @names.each { |name| Dictionary.define_dictionary_methods(name) }
    end

    def slug_dictionary
      cuisines_dictionary.merge(locations_dictionary).merge(categories_dictionary)
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

      # define_method(dictionary_name) do
      #   dictionary = instance_variable_get("@#{dictionary_name}") ||= build_dictionary(name)
      #   instance_variable_set("@#{dictionary_name}", dictionary)
      # end

      # define_method("#{name}?") do |term|
      #   send(dictionary_name).key?(term)
      # end
    end

    def dictionaries
      @dictionaries ||= methods.grep /^.*_dictionary/
    end

    private

    def build_dictionary(name)
      puts "building dictionary"
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
