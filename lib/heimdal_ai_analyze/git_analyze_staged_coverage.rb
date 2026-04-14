#!/usr/bin/env ruby
# frozen_string_literal: true

# Summarize SimpleCov line hits for lines touched in `git diff --cached` (app/, lib/).
# Reads coverage/.resultset.json from the last COVERAGE=true test run (not invoked by this script).

require "json"
require "shellwords"

root = File.expand_path(ARGV[0] || Dir.pwd)
resultset_path = File.join(root, "coverage", ".resultset.json")

unless File.file?(resultset_path)
  warn "  No coverage/.resultset.json — run: COVERAGE=true bundle exec rspec"
  warn "  Then re-run git analyze to see per-file changed-line coverage."
  exit 0
end

raw = JSON.parse(File.read(resultset_path))

def merge_line_arrays(a, b)
  return b if a.nil? || a.empty?
  return a if b.nil? || b.empty?
  len = [a.size, b.size].max
  (0...len).map do |i|
    va = a[i]
    vb = b[i]
    if va.nil? && vb.nil?
      nil
    elsif va.nil?
      vb
    elsif vb.nil?
      va
    else
      [va.to_i, vb.to_i].max
    end
  end
end

merged = {}
raw.each_value do |payload|
  cov = payload["coverage"] || {}
  cov.each do |abs_path, info|
    lines = info["lines"] || info
    next unless lines.is_a?(Array)

    merged[abs_path] = merge_line_arrays(merged[abs_path], lines)
  end
end

diff = `git -C #{Shellwords.escape(root)} diff --cached --unified=3 -- app lib 2>/dev/null`
if diff.strip.empty?
  warn "  (no staged app/lib diff for coverage mapping)"
  exit 0
end

def each_staged_file_diff(diff_text)
  diff_text.split(/(?=^diff --git )/m).each do |chunk|
    chunk = chunk.strip
    next if chunk.empty?

    next unless chunk =~ %r{\Adiff --git a/(.+?) b/}

    path = Regexp.last_match(1)
    yield path, chunk
  end
end

# New-file line numbers for lines introduced or modified on the right-hand side of the diff.
def changed_executable_line_numbers(chunk)
  lines = []
  new_ln = nil
  chunk.each_line do |line|
    if line =~ /^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@/
      new_ln = Regexp.last_match(3).to_i
      next
    end
    next if line.start_with?("---", "+++", "diff ", "\\")

    if line.start_with?("+") && !line.start_with?("+++")
      lines << new_ln
      new_ln += 1
    elsif line.start_with?("-") && !line.start_with?("---")
      # old side only
      next
    elsif line.start_with?(" ")
      new_ln += 1
    end
  end
  lines.uniq.sort
end

dim = "\033[2m"
reset = "\033[0m"
green = "\033[1;32m"
yellow = "\033[33m"
use_color = $stderr.tty?
unless use_color
  dim = reset = green = yellow = ""
end

printed = false
each_staged_file_diff(diff) do |rel, chunk|
  next unless rel.end_with?(".rb")
  next unless rel.start_with?("app/", "lib/")
  next if rel.match?(%r{\Aapp/(assets|javascript|views|helpers|mailers|jobs)/})

  abs = File.expand_path(File.join(root, rel))
  changed = changed_executable_line_numbers(chunk)
  next if changed.empty?

  cov = merged[abs]
  unless cov
    key = merged.keys.find { |p| File.expand_path(p) == abs || p.end_with?("/#{rel}") }
    cov = key ? merged[key] : nil
  end
  unless cov
    warn "  #{rel}  →  #{yellow}no SimpleCov data for this file#{reset}  (not loaded in last COVERAGE run)"
    printed = true
    next
  end

  executable_changed = changed.select do |ln|
    idx = ln - 1
    idx >= 0 && !cov[idx].nil?
  end

  if executable_changed.empty?
    warn "  #{rel}  →  #{dim}n/a (no executable changed lines in diff)#{reset}"
    printed = true
    next
  end

  covered = executable_changed.count { |ln| cov[ln - 1].to_i.positive? }
  total = executable_changed.size
  pct = ((100.0 * covered) / total).round

  color = pct >= 80 ? green : yellow
  warn "  #{rel}  →  #{color}#{pct}%#{reset} changed-line coverage  (#{covered}/#{total} executable changed lines hit)"
  printed = true
end

unless printed
  warn "  #{dim}(no staged Ruby files under app/ or lib/ to map)#{reset}"
end

warn "#{dim}  Source: coverage/.resultset.json vs git diff --cached#{reset}"

exit 0
