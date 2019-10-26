module Slugcatcher
  module Model
    def slugcatcher(options = {})
      Slugcatcher.models << [self, options[:lookup] || :name]
    end
  end
end
