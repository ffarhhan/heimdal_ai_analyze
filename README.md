# Heimdal AI Analyze

[![Repo views](https://komarev.com/ghpvc/?username=ffarhhan-heimdal-ai-analyze&label=Repo+views&style=for-the-badge)](https://github.com/ffarhhan/heimdal_ai_analyze)

[![Gem Version](https://badge.fury.io/rb/heimdal_ai_analyze.svg)](https://rubygems.org/gems/heimdal_ai_analyze)

**Heimdal AI Analyze** is a Ruby gem that adds a **git pre-commit** hook for **AI-assisted review** of your **staged diff**. Use `git analyze` to run the review before your commit; a normal `git commit` does not trigger analysis unless you opt in.

_Sees every line. Judges every commit. No bad code crosses the Bifrost._

- **RubyGems:** [rubygems.org/gems/heimdal_ai_analyze](https://rubygems.org/gems/heimdal_ai_analyze)
- **Source:** [github.com/ffarhhan/heimdal_ai_analyze](https://github.com/ffarhhan/heimdal_ai_analyze)

## Installation

```bash
gem install heimdal_ai_analyze
```

With Bundler:

```ruby
# Gemfile
gem "heimdal_ai_analyze", group: :development
```

```bash
bundle install
```

Requires **Ruby ≥ 3.1**.

## How it works

1. **You run `git analyze -m "message"`** — A `git commit` alias that runs Heimdal’s review **before** your changes are committed.

2. **Staged changes only** — Only files in the commit are analyzed; the rest of the tree is untouched.

3. **Five dimensions** — **Security**, **duplication**, **complexity**, **style**, and **tests**.

4. **Severity** — Issues are reported with location, explanation, and a suggested fix (**critical**, **warning**, **info**).

**Result:** **Critical** findings **block** the commit until addressed. With no critical issues, the commit can proceed; lower severities are advisory.

## One-time setup (per repository)

Run from the repository root:

```bash
bundle exec heimdal-ai-analyze-install
# or, if the executable is on your PATH:
heimdal-ai-analyze-install
```

This links the gem’s pre-commit hook, registers the `git analyze` alias (`ANALYZE=true git commit …`), and stores the gem path in local git config. If an analysis binary is found, its path may be saved locally as well.

## API key

The hook needs **`CURSOR_API_KEY`** whenever you run `git analyze`.

- **This shell only:** `export CURSOR_API_KEY="…"` lasts for the current terminal session.
- **Every session:** add that `export` to your shell profile (for example `~/.zshrc` or `~/.bashrc`), **or** keep the key in a **repository-root `.env`** file and add `.env` to `.gitignore` so it is never committed. The hook loads supported env files when it runs.

For additional options and examples, see **`templates/env.hook.example`** inside the installed gem (`gem contents heimdal_ai_analyze` or `$(gem env gemdir)/gems/heimdal_ai_analyze-*`).

## Usage

```bash
git analyze -m "Your commit message"   # review staged changes, then commit if allowed
```

## License

MIT — see [LICENSE.txt](LICENSE.txt).
