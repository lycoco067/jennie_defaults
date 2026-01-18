# frozen_string_literal: true

require "exception_notification"

module JennieDefaults
  module ErrorNotification
    class << self
      def configure(app)
        config = JennieDefaults.configuration

        app.config.middleware.use ExceptionNotification::Rack,
                                  email: {
                                    email_prefix: "[#{config.app_name} ERROR] ",
                                    sender_address: %("#{config.app_name} Errors" <errors@#{config.app_name.downcase.gsub(/\s+/, '')}.com>),
                                    exception_recipients: [config.error_email]
                                  },
                                  error_grouping: true,
                                  error_grouping_period: 5.minutes,
                                  ignore_exceptions: ignored_exceptions,
                                  ignore_crawlers: ignored_crawlers
      end

      private

      def ignored_exceptions
        %w[
          ActionController::RoutingError
          ActionController::InvalidAuthenticityToken
          ActionController::BadRequest
          ActiveRecord::RecordNotFound
          ActionController::UnknownFormat
        ] + ExceptionNotifier.ignored_exceptions
      end

      def ignored_crawlers
        %w[
          Googlebot
          bingbot
          YandexBot
          Baiduspider
          DuckDuckBot
          Slurp
          facebookexternalhit
          Twitterbot
          LinkedInBot
        ]
      end
    end
  end
end
