# frozen_string_literal: true

require_relative "lib/heimdal_ai_analyze/version"

Gem::Specification.new do |spec|
  spec.name = "heimdal_ai_analyze"
  spec.version = HeimdalAiAnalyze::VERSION
  spec.authors = ["ffarhhan", "namanverma98"]
  spec.email = ["ffarhhan@users.noreply.github.com", "namanv98@gmail.com"]

  spec.summary = "Heimdal AI Analyze — git pre-commit hook for AI-assisted review of staged diffs (git analyze)"
  spec.description = "Heimdal AI Analyze installs a git pre-commit hook that runs an AI-assisted code review of your staged diff when you commit with analysis enabled (e.g. `git analyze -m \"message\"`). Reviews security, duplication, complexity, style, and tests; critical issues can block the commit. Requires CURSOR_API_KEY in the environment or a repo-local `.env`."
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
