# frozen_string_literal: true

module JennieDefaults
  module MailSettings
    class << self
      def configure(app)
        config = JennieDefaults.configuration

        # Resend 설정
        app.config.action_mailer.delivery_method = :resend

        # API 키 설정
        if config.resend_api_key || ENV["RESEND_API_KEY"]
          Resend.api_key = config.resend_api_key || ENV["RESEND_API_KEY"]
        end

        # 기본 메일 설정
        app.config.action_mailer.perform_caching = false
        app.config.action_mailer.raise_delivery_errors = Rails.env.development?
        app.config.action_mailer.perform_deliveries = !Rails.env.test?

        # 기본 발신자
        app.config.action_mailer.default_options = {
          from: config.default_from
        }

        # Development에서는 letter_opener 사용 (있으면)
        configure_development_mailer(app) if Rails.env.development?
      end

      private

      def configure_development_mailer(app)
        require "letter_opener"
        app.config.action_mailer.delivery_method = :letter_opener
        app.config.action_mailer.perform_deliveries = true
      rescue LoadError
        # letter_opener 없으면 그냥 로그
        app.config.action_mailer.delivery_method = :logger
      end
    end
  end
end
