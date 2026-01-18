# JennieDefaults

Rails 앱을 위한 공통 설정, 헬퍼, 제너레이터 모음. 여러 Rails 프로젝트에서 반복되는 설정을 자동화합니다.

## 기능

- **보안 설정**: HTTP 보안 헤더, SSL, CSP, Session 보안 자동 설정
- **에러 알림**: exception_notification + Resend 연동
- **시간대/로케일**: Seoul 시간대, 한국어 기본 설정
- **메일 설정**: Resend 기본 설정, development에서 letter_opener 자동 연동
- **공통 헬퍼**: 날짜, 통화, 포맷, 마스킹 헬퍼
- **커스텀 제너레이터**: Service, FormObject 생성기

## 설치

Gemfile에 추가:

```ruby
# GitHub에서 직접
gem "jennie_defaults", git: "https://github.com/jenniesu/jennie_defaults.git"

# 또는 로컬 개발용
gem "jennie_defaults", path: "~/develop/jennie_defaults"
```

## 설정

`config/initializers/jennie_defaults.rb` 파일 생성:

```ruby
JennieDefaults.configure do |config|
  config.app_name = "MyApp"
  config.error_email = "errors@myapp.com"
  config.resend_api_key = ENV['RESEND_API_KEY']
  config.time_zone = "Seoul"              # 기본값: Seoul
  config.default_locale = :ko              # 기본값: :ko
  config.enable_security_headers = true    # 기본값: true
  config.enable_error_notification = Rails.env.production?  # 기본값: true
end
```

## 헬퍼 사용법

### 날짜 헬퍼

```erb
<%= korean_date(Time.current) %>       <%# 2024년 01월 15일 %>
<%= dot_date(Time.current) %>          <%# 2024.01.15 %>
<%= korean_time(Time.current) %>       <%# 오후 3:30 %>
<%= korean_datetime(Time.current) %>   <%# 2024년 01월 15일 오후 3:30 %>
<%= time_ago_korean(1.hour.ago) %>     <%# 1시간 전 %>
<%= d_day(7.days.from_now) %>          <%# D-7 %>
```

### 통화 헬퍼

```erb
<%= korean_won(1234567) %>         <%# 1,234,567원 %>
<%= won_symbol(1234567) %>         <%# ₩1,234,567 %>
<%= compact_won(123456789) %>      <%# 1.2억원 %>
<%= percent_change(15.3) %>        <%# +15.3% %>
<%= percent_change(-7.2) %>        <%# -7.2% %>
```

### 포맷 헬퍼

```erb
<%= phone_format("01012345678") %>     <%# 010-1234-5678 %>
<%= mask_name("홍길동") %>              <%# 홍*동 %>
<%= mask_phone("01012345678") %>       <%# 010-****-5678 %>
<%= mask_email("test@example.com") %>  <%# tes***@example.com %>
<%= file_size(1536000) %>              <%# 1.5 MB %>
<%= compact_number(1234567) %>         <%# 1.2M %>
<%= yes_no(true) %>                    <%# 예 %>
```

## 제너레이터

### Service 생성

```bash
# 기본 서비스
bin/rails generate service Payment

# 파라미터 포함
bin/rails generate service Payment user amount

# 테스트 제외
bin/rails generate service Payment --skip-test
```

생성되는 파일:
- `app/services/payment_service.rb`
- `test/services/payment_service_test.rb`

### FormObject 생성

```bash
# 기본 폼
bin/rails generate form_object UserRegistration

# 속성 포함
bin/rails generate form_object UserRegistration email:string name:string password:string
```

생성되는 파일:
- `app/forms/user_registration_form.rb`
- `test/forms/user_registration_form_test.rb`

## 보안 설정

자동으로 적용되는 보안 헤더:

- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: camera=(), microphone=(), geolocation=(self)`

Production 환경에서 추가 적용:
- Force SSL
- HSTS (1년, subdomains 포함)

## 에러 알림

Production 환경에서 자동으로 에러 메일 발송:
- Resend를 통해 발송
- 에러 그룹핑 (5분 단위)
- 크롤러 무시 (Googlebot, bingbot 등)
- 일반적인 에러 무시 (404, InvalidAuthenticityToken 등)

## License

MIT License
