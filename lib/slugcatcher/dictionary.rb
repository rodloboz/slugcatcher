module Slugcatcher
  class Dictionary
    def initialize(models)
      models.each do |model|
        Dictionary.define_dictionary_methods(model)
      end
    end

    def self.define_dictionary_methods(model)
      attr_name = model.name.underscore
      dictionary_name = "#{attr_name.pluralize}_dictionary"

      define_method(dictionary_name) do
        instance_variable_set("@#{dictionary_name}", build_dictionary(name))
      end

      define_method("#{attr_name}?") do |term|
        send(dictionary_name).key?(term)
      end
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
