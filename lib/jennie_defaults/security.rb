# frozen_string_literal: true

module JennieDefaults
  module Security
    class << self
      def configure(app)
        configure_headers(app)
        configure_ssl(app) if Rails.env.production?
        configure_session(app)
        configure_csp(app)
      end

      private

      def configure_headers(app)
        app.config.action_dispatch.default_headers = {
          # Clickjacking 방지
          "X-Frame-Options" => "SAMEORIGIN",

          # MIME 스니핑 방지
          "X-Content-Type-Options" => "nosniff",

          # XSS 필터
          "X-XSS-Protection" => "1; mode=block",

          # Referrer 정책
          "Referrer-Policy" => "strict-origin-when-cross-origin",

          # 권한 정책 (카메라, 마이크 등 제한)
          "Permissions-Policy" => "camera=(), microphone=(), geolocation=(self)"
        }
      end

      def configure_ssl(app)
        app.config.force_ssl = true
        app.config.ssl_options = {
          hsts: { subdomains: true, preload: true, expires: 1.year }
        }
      end

      def configure_session(app)
        app_name = JennieDefaults.configuration.app_name.downcase.gsub(/\s+/, "_")

        app.config.session_store :cookie_store,
                                 key: "_#{app_name}_session",
                                 secure: Rails.env.production?,
                                 httponly: true,
                                 same_site: :lax
      end

      def configure_csp(app)
        app.config.content_security_policy do |policy|
          policy.default_src :self
          policy.font_src    :self, "https://fonts.gstatic.com", "https://cdn.jsdelivr.net"
          policy.img_src     :self, :data, :blob, "https:"
          policy.object_src  :none
          policy.script_src  :self, "https://cdn.jsdelivr.net", "https://ga.jspm.io"
          policy.style_src   :self, :unsafe_inline, "https://fonts.googleapis.com", "https://cdn.jsdelivr.net"
          policy.connect_src :self, "https:", "wss:"
          policy.frame_ancestors :self

          # Turbo 호환 (development)
          policy.script_src(*policy.script_src, :unsafe_eval) if Rails.env.development?
        end

        app.config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
        app.config.content_security_policy_nonce_directives = %w[script-src]
      end
    end
  end
end
