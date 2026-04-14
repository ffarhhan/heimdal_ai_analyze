# Heimdal AI Analyze

Ruby gem that installs a **git pre-commit** hook for **AI-assisted review** of your **staged diff** via the [Cursor Agent CLI](https://cursor.com/docs/cli/overview). The hook runs only when you commit with analysis enabled (e.g. `git analyze -m "message"`), not on normal commits.

## Requirements

1. **Cursor Agent CLI** — install from [cursor.com/install](https://cursor.com/install) and ensure `agent` or `cursor-agent` is on your `PATH` (or set `CURSOR_AGENT_BIN`).
2. **`CURSOR_API_KEY`** — export in your environment, or use a repo-local `scripts/.env.hook`, or `~/.config/heimdal_ai_analyze/env` (see below).

## Install the gem

```bash
gem install heimdal_ai_analyze
```

Or with Bundler:

```ruby
# Gemfile
gem "heimdal_ai_analyze", group: :development
```

```bash
bundle install
```

## One-time setup per repository

From the git repository root:

```bash
bundle exec heimdal-ai-analyze-install
# or, if the gem executable is on PATH:
heimdal-ai-analyze-install
```

This symlinks `.git/hooks/pre-commit` to the gem’s hook, sets `git analyze` alias (`ANALYZE=true git commit …`), records `heimdalAiAnalyze.gemPath`, and tries to save `cursorHook.agentPath` for the Cursor Agent binary.

## Credentials

**Minimum:** set an API key for the Cursor Agent:

```bash
export CURSOR_API_KEY="your-key"
```

Optional locations (loaded in order; later sources override earlier ones):

1. `~/.config/heimdal_ai_analyze/env` or `$XDG_CONFIG_HOME/heimdal_ai_analyze/env` — `export CURSOR_API_KEY=...`
2. `scripts/.env.hook` in the project (gitignored) — copy from `templates/env.hook.example` in this gem if you open the installed path under `$(gem env gemdir)`.

## Usage

```bash
git analyze -m "Your commit message"   # runs AI review on staged changes, then commits if allowed
git commit -m "message"                   # normal commit (hook skips AI unless ANALYZE=true)
git commit --no-verify                    # bypass hooks when needed
```

## Development

Clone [github.com/ffarhhan/heimdal_ai_analyze](https://github.com/ffarhhan/heimdal_ai_analyze):

```bash
git clone -o personal git@github.com:ffarhhan/heimdal_ai_analyze.git
cd heimdal_ai_analyze
gem build heimdal_ai_analyze.gemspec
gem install ./heimdal_ai_analyze-*.gem --local
```

## Publish to RubyGems.org (maintainers)

1. [Create an account](https://rubygems.org/sign_up) and enable MFA as required.
2. `gem signin` with a [RubyGems API key](https://rubygems.org/profile/edit) (push scope).
3. Bump `lib/heimdal_ai_analyze/version.rb`, then:

```bash
gem build heimdal_ai_analyze.gemspec
gem push heimdal_ai_analyze-VERSION.gem
```

## License

MIT — see [LICENSE.txt](LICENSE.txt).
