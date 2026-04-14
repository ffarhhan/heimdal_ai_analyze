# frozen_string_literal: true

require_relative "lib/heimdal_ai_analyze/version"

Gem::Specification.new do |spec|
  spec.name = "heimdal_ai_analyze"
  spec.version = HeimdalAiAnalyze::VERSION
  spec.authors = ["ffarhhan"]
  spec.email = ["ffarhhan@users.noreply.github.com"]

  spec.summary = "Heimdal AI Analyze — Cursor Agent pre-commit gate for staged diffs"
  spec.description = "Installs a git pre-commit hook that runs Cursor Agent on ANALYZE=true commits (e.g. git analyze). Requires CURSOR_API_KEY and the Cursor Agent CLI."
  spec.homepage = "https://github.com/ffarhhan/heimdal_ai_analyze"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ffarhhan/heimdal_ai_analyze"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = %w[heimdal_ai_analyze.gemspec LICENSE.txt README.md] +
    Dir["lib/**/*.rb"] + Dir["exe/*"] + Dir["templates/*"]
  spec.files = spec.files.select { |f| File.file?(File.join(__dir__, f)) }
  spec.bindir = "exe"
  spec.executables = ["heimdal-ai-analyze-install"]
  spec.require_paths = ["lib"]
end
