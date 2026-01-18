# frozen_string_literal: true

require_relative "jennie_defaults/version"
require_relative "jennie_defaults/configuration"

module JennieDefaults
  class Error < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

require_relative "jennie_defaults/railtie" if defined?(Rails::Railtie)
