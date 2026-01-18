# frozen_string_literal: true

class FormObjectGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "attribute:type"

  class_option :skip_test, type: :boolean, default: false, desc: "Skip test file generation"

  def create_form_object_file
    template "form_object.rb.tt", "app/forms/#{file_path}_form.rb"
  end

  def create_test_file
    return if options[:skip_test]

    template "form_object_test.rb.tt", "test/forms/#{file_path}_form_test.rb"
  end

  private

  def file_path
    file_name.underscore
  end

  def parsed_attributes
    @parsed_attributes ||= attributes.map do |attr|
      name, type = attr.split(":")
      { name: name, type: type || "string" }
    end
  end
end
