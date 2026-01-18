# frozen_string_literal: true

require_relative "security"
require_relative "error_notification"
require_relative "mail_settings"
require_relative "helpers/date_helper"
require_relative "helpers/currency_helper"
require_relative "helpers/format_helper"

module JennieDefaults
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      # ═══════════════════════════════════════
      # 1. 시간대 설정
      # ═══════════════════════════════════════
      app.config.time_zone = JennieDefaults.configuration.time_zone

      # ═══════════════════════════════════════
      # 2. 로케일 설정
      # ═══════════════════════════════════════
      app.config.i18n.default_locale = JennieDefaults.configuration.default_locale
      app.config.i18n.available_locales = %i[ko en]
      app.config.i18n.fallbacks = [:en]
    end

    initializer "jennie_defaults.security", before: :load_config_initializers do |app|
      if JennieDefaults.configuration.enable_security_headers
        JennieDefaults::Security.configure(app)
      end
    end

    initializer "jennie_defaults.mail" do |app|
      JennieDefaults::MailSettings.configure(app)
    end

    initializer "jennie_defaults.error_notification", after: :load_config_initializers do |app|
      if JennieDefaults.configuration.enable_error_notification && Rails.env.production?
        JennieDefaults::ErrorNotification.configure(app)
      end
    end

    initializer "jennie_defaults.helpers" do
      ActiveSupport.on_load(:action_view) do
        include JennieDefaults::Helpers::DateHelper
        include JennieDefaults::Helpers::CurrencyHelper
        include JennieDefaults::Helpers::FormatHelper
      end

      ActiveSupport.on_load(:action_controller) do
        helper JennieDefaults::Helpers::DateHelper
        helper JennieDefaults::Helpers::CurrencyHelper
        helper JennieDefaults::Helpers::FormatHelper
      end
    end

    # ═══════════════════════════════════════
    # Generator 기본값
    # ═══════════════════════════════════════
    config.generators do |g|
      g.test_framework :minitest
      g.system_tests nil
      g.stylesheets false
      g.helper false
      g.jbuilder false
    end

    # Generator 경로 등록
    generators do
      require_relative "../generators/service/service_generator"
      require_relative "../generators/form_object/form_object_generator"
    end
  end
end
