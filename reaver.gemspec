# frozen_string_literal: true

require_relative 'lib/reaver/version'

# https://guides.rubygems.org/specification-reference/
Gem::Specification.new do |s|
  s.name = 'reaver'
  s.summary = 'A tool to downloads and track updates of things on the Net.'
  s.version = Reaver::VERSION
  s.platform = Gem::Platform::RUBY

  s.description = <<-DESCRIPTION
    A tool that allows to download and track the latest version of stuff on the net.
    Define your collections in .yml and launch Reaver to retrieve everything.
  DESCRIPTION

  s.email = 'szorfein@protonmail.com'
  s.homepage = 'https://github.com/szorfein/reaver'
  s.license = 'MIT'
  s.author = 'szorfein'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/szorfein/reaver/issues',
    'changelog_uri' => 'https://github.com/szorfein/reaver/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/szorfein/reaver',
    'wiki_uri' => 'https://github.com/szorfein/reaver/wiki',
    'funding_uri' => 'https://patreon.com/szorfein'
  }

  s.files = Dir.glob('{lib,bin}/**/*', File::FNM_DOTMATCH).reject do |f|
    File.directory?(f)
  end

  s.files += %w[CHANGELOG.md LICENSE README.md]
  s.files += %w[reaver.gemspec]

  s.bindir = 'bin'
  s.executables << 'reaver'
  s.extra_rdoc_files = %w[README.md]

  s.cert_chain = %w[certs/szorfein.pem]
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')

  s.required_ruby_version = '>=2.6'
  s.add_dependency 'marcel'
  s.add_dependency 'paint', '~> 2.3'
  s.add_dependency 'whirly', '~> 0.3'
end
