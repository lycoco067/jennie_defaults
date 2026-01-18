# frozen_string_literal: true

module JennieDefaults
  module Helpers
    module CurrencyHelper
      # ═══════════════════════════════════════
      # 통화 포맷
      # ═══════════════════════════════════════

      # 1,234,567원
      def korean_won(amount)
        return "0원" if amount.nil? || amount.zero?

        "#{number_with_delimiter_custom(amount.to_i)}원"
      end

      # ₩1,234,567
      def won_symbol(amount)
        return "₩0" if amount.nil? || amount.zero?

        "₩#{number_with_delimiter_custom(amount.to_i)}"
      end

      # $1,234.56
      def usd(amount)
        return "$0.00" if amount.nil? || amount.zero?

        "$#{number_with_delimiter_custom(format('%.2f', amount))}"
      end

      # 1.2만, 3.4억
      def compact_won(amount)
        return "0원" if amount.nil? || amount.zero?

        case amount.abs
        when 0...10_000
          "#{number_with_delimiter_custom(amount.to_i)}원"
        when 10_000...100_000_000
          man = (amount / 10_000.0).round(1)
          formatted = man == man.to_i ? man.to_i.to_s : man.to_s
          "#{formatted}만원"
        when 100_000_000...1_000_000_000_000
          eok = (amount / 100_000_000.0).round(1)
          formatted = eok == eok.to_i ? eok.to_i.to_s : eok.to_s
          "#{formatted}억원"
        else
          jo = (amount / 1_000_000_000_000.0).round(1)
          formatted = jo == jo.to_i ? jo.to_i.to_s : jo.to_s
          "#{formatted}조원"
        end
      end

      # +15.3%, -7.2%
      def percent_change(value, precision: 1)
        return "0%" if value.nil? || value.zero?

        formatted = format("%.#{precision}f", value.abs)
        value.positive? ? "+#{formatted}%" : "-#{formatted}%"
      end

      # 기본 퍼센트 (부호 없이)
      def percent(value, precision: 1)
        return "0%" if value.nil?

        "#{format("%.#{precision}f", value)}%"
      end

      # 숫자에 천 단위 구분자 (ActionView 없이 독립 동작)
      def number_with_delimiter_custom(number)
        parts = number.to_s.split(".")
        parts[0] = parts[0].reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        parts.join(".")
      end
    end
  end
end
