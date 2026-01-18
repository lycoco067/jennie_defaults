# frozen_string_literal: true

module JennieDefaults
  module Helpers
    module DateHelper
      # ═══════════════════════════════════════
      # 한국식 날짜 포맷
      # ═══════════════════════════════════════

      # 2024년 1월 15일
      def korean_date(date)
        return nil if date.nil?

        date.strftime("%Y년 %m월 %d일")
      end

      # 2024.01.15
      def dot_date(date)
        return nil if date.nil?

        date.strftime("%Y.%m.%d")
      end

      # 01/15
      def short_date(date)
        return nil if date.nil?

        date.strftime("%m/%d")
      end

      # 오후 3:30
      def korean_time(time)
        return nil if time.nil?

        hour = time.hour
        period = hour < 12 ? "오전" : "오후"
        display_hour = hour.zero? ? 12 : (hour > 12 ? hour - 12 : hour)
        "#{period} #{display_hour}:#{time.strftime('%M')}"
      end

      # 2024년 1월 15일 오후 3:30
      def korean_datetime(datetime)
        return nil if datetime.nil?

        "#{korean_date(datetime)} #{korean_time(datetime)}"
      end

      # 방금 전, 5분 전, 3시간 전, 어제, 3일 전
      def time_ago_korean(time)
        return nil if time.nil?

        seconds = (Time.current - time).to_i

        case seconds
        when 0..59
          "방금 전"
        when 60..3599
          "#{seconds / 60}분 전"
        when 3600..86_399
          "#{seconds / 3600}시간 전"
        when 86_400..172_799
          "어제"
        when 172_800..604_799
          "#{seconds / 86_400}일 전"
        when 604_800..2_419_199
          "#{seconds / 604_800}주 전"
        else
          korean_date(time)
        end
      end

      # D-7, D-Day, D+3
      def d_day(target_date)
        return nil if target_date.nil?

        days = (target_date.to_date - Date.current).to_i

        case days
        when 0
          "D-Day"
        when 1..Float::INFINITY
          "D-#{days}"
        else
          "D+#{days.abs}"
        end
      end

      # 이번 주 월요일 ~ 일요일
      def week_range(date = Date.current)
        start_date = date.beginning_of_week(:monday)
        end_date = date.end_of_week(:monday)
        "#{dot_date(start_date)} ~ #{dot_date(end_date)}"
      end

      # 이번 달 1일 ~ 말일
      def month_range(date = Date.current)
        start_date = date.beginning_of_month
        end_date = date.end_of_month
        "#{dot_date(start_date)} ~ #{dot_date(end_date)}"
      end
    end
  end
end
