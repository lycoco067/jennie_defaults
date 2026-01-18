# frozen_string_literal: true

module JennieDefaults
  module Helpers
    module FormatHelper
      # ═══════════════════════════════════════
      # 전화번호 포맷
      # ═══════════════════════════════════════

      # 010-1234-5678
      def phone_format(phone)
        return nil if phone.blank?

        digits = phone.gsub(/\D/, "")

        case digits.length
        when 11 # 010-1234-5678
          "#{digits[0..2]}-#{digits[3..6]}-#{digits[7..10]}"
        when 10 # 02-1234-5678 or 031-123-4567
          if digits.start_with?("02")
            "#{digits[0..1]}-#{digits[2..5]}-#{digits[6..9]}"
          else
            "#{digits[0..2]}-#{digits[3..5]}-#{digits[6..9]}"
          end
        when 9 # 02-123-4567
          "#{digits[0..1]}-#{digits[2..4]}-#{digits[5..8]}"
        else
          phone
        end
      end

      # ═══════════════════════════════════════
      # 이름 마스킹
      # ═══════════════════════════════════════

      # 홍*동
      def mask_name(name)
        return nil if name.blank?
        return "*" if name.length == 1
        return "#{name[0]}*" if name.length == 2

        "#{name[0]}#{'*' * (name.length - 2)}#{name[-1]}"
      end

      # 010-****-5678
      def mask_phone(phone)
        return nil if phone.blank?

        formatted = phone_format(phone)
        formatted&.gsub(/(\d{2,3})-(\d{3,4})-(\d{4})/, '\1-****-\3')
      end

      # abc***@gmail.com
      def mask_email(email)
        return nil if email.blank?

        local, domain = email.split("@")
        return email if local.nil? || domain.nil?

        if local.length <= 3
          "#{local[0]}**@#{domain}"
        else
          "#{local[0..2]}#{'*' * [local.length - 3, 3].min}@#{domain}"
        end
      end

      # ═══════════════════════════════════════
      # 파일 크기
      # ═══════════════════════════════════════

      # 1.5 MB, 256 KB
      def file_size(bytes)
        return "0 B" if bytes.nil? || bytes.zero?

        units = %w[B KB MB GB TB]
        exp = (Math.log(bytes) / Math.log(1024)).to_i
        exp = [exp, units.length - 1].min

        size = bytes.to_f / (1024**exp)
        "#{size.round(1)} #{units[exp]}"
      end

      # ═══════════════════════════════════════
      # 숫자 압축
      # ═══════════════════════════════════════

      # 1.2K, 3.4M
      def compact_number(number)
        return "0" if number.nil? || number.zero?

        case number.abs
        when 0...1_000
          number.to_s
        when 1_000...1_000_000
          value = (number / 1_000.0).round(1)
          formatted = value == value.to_i ? value.to_i.to_s : value.to_s
          "#{formatted}K"
        when 1_000_000...1_000_000_000
          value = (number / 1_000_000.0).round(1)
          formatted = value == value.to_i ? value.to_i.to_s : value.to_s
          "#{formatted}M"
        else
          value = (number / 1_000_000_000.0).round(1)
          formatted = value == value.to_i ? value.to_i.to_s : value.to_s
          "#{formatted}B"
        end
      end

      # ═══════════════════════════════════════
      # Boolean 표시
      # ═══════════════════════════════════════

      # 예/아니오
      def yes_no(value)
        value ? "예" : "아니오"
      end

      # O/X
      def ox(value)
        value ? "O" : "X"
      end

      # ✓/✗
      def check_mark(value)
        value ? "✓" : "✗"
      end

      # ═══════════════════════════════════════
      # 텍스트 처리
      # ═══════════════════════════════════════

      # 긴 텍스트 자르기
      def truncate_korean(text, length: 30, omission: "...")
        return nil if text.blank?
        return text if text.length <= length

        "#{text[0, length - omission.length]}#{omission}"
      end

      # 줄바꿈을 <br>로 변환
      def nl2br(text)
        return nil if text.blank?

        text.gsub(/\r?\n/, "<br>").html_safe
      end
    end
  end
end
