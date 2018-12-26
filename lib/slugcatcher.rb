require "active_support"
require 'active_support/core_ext/module'
require "slugcatcher/version"

require "slugcatcher/railtie" if defined?(Rails)

module Slugcatcher
  extend ActiveSupport::Autoload

  autoload :Dictionary
  autoload :Lookup
  autoload :Model

  class << self
    attr_accessor :models
  end

  self.models = []

  def self.lookup(slugs)
    lookup = Slugcatcher::Lookup.new(models, slugs)
  end
end

ActiveSupport.on_load(:active_record) do
  extend Slugcatcher::Model
end

