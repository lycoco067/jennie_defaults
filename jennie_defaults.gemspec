# frozen_string_literal: true

require_relative "lib/jennie_defaults/version"

Gem::Specification.new do |spec|
  spec.name = "jennie_defaults"
  spec.version = JennieDefaults::VERSION
  spec.authors = ["Jennie"]
  spec.email = ["lycoco067@gmail.com"]

  spec.summary = "Jennie's Rails defaults for all projects"
  spec.description = "Common configuration, helpers, and generators for Rails apps. Includes security headers, error notification with Resend, Korean locale/timezone, and useful helpers."
  spec.homepage = "https://github.com/jenniesu/jennie_defaults"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jenniesu/jennie_defaults"
  spec.metadata["changelog_uri"] = "https://github.com/jenniesu/jennie_defaults/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "resend", ">= 0.8"
  spec.add_dependency "exception_notification", ">= 4.5"
end
