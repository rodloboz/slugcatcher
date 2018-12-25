module Slugcatcher
  module Model
    def slugcatcher
      Slugcatcher.models << self
    end
  end
end
