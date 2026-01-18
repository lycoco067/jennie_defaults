# frozen_string_literal: true

class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :methods, type: :array, default: [], banner: "method method"

  class_option :skip_test, type: :boolean, default: false, desc: "Skip test file generation"

  def create_service_file
    template "service.rb.tt", "app/services/#{file_path}_service.rb"
  end

  def create_test_file
    return if options[:skip_test]

    template "service_test.rb.tt", "test/services/#{file_path}_service_test.rb"
  end

  private

  def file_path
    file_name.underscore
  end
end
