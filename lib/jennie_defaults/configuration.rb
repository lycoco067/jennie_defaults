# frozen_string_literal: true

module JennieDefaults
  class Configuration
    attr_accessor :error_email,
                  :resend_api_key,
                  :app_name,
                  :time_zone,
                  :default_locale,
                  :enable_security_headers,
                  :enable_error_notification,
                  :default_from_email

    def initialize
      @error_email = "lycoco067@gmail.com"
      @resend_api_key = nil
      @app_name = "MyApp"
      @time_zone = "Seoul"
      @default_locale = :ko
      @enable_security_headers = true
      @enable_error_notification = true
      @default_from_email = nil
    end

    def default_from
      @default_from_email || "#{app_name} <noreply@#{app_name.downcase.gsub(/\s+/, '')}.com>"
    end
  end
end
