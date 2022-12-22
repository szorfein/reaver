# frozen_string_literal: true

require_relative 'lib/harpoon/version'

# https://guides.rubygems.org/specification-reference/
Gem::Specification.new do |s|
  s.name = 'harpoon'
  s.summary = 'A tool to downloads and search for updates of things on the Net.'
  s.version = Harpoon::VERSION
  s.platform = Gem::Platform::RUBY

  s.description = <<-DESCRIPTION
    A tool to download and search for updates of things on the Net. Define collections in yaml with a delay in seconds and launch Harpoon.
  DESCRIPTION

  s.email = 'szorfein@protonmail.com'
  s.homepage = 'https://github.com/szorfein/harpoon'
  s.license = 'MIT'
  s.author = 'szorfein'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/szorfein/harpoon/issues',
    'changelog_uri' => 'https://github.com/szorfein/harpoon/blob/main/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/szorfein/harpoon',
    'wiki_uri' => 'https://github.com/szorfein/harpoon/wiki',
    'funding_uri' => 'https://patreon.com/szorfein',
  }

  s.files = Dir.glob('{lib,bin}/**/*', File::FNM_DOTMATCH).reject do |f|
    File.directory?(f)
  end

  s.files += %w[CHANGELOG.md LICENSE README.md]
  s.files += %w[harpoon.gemspec]

  s.bindir = 'bin'
  s.executables << 'harpoon'
  s.extra_rdoc_files = %w[README.md]

  s.cert_chain = %w[certs/szorfein.pem]
  s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')

  s.required_ruby_version = '>=2.6'
  s.add_dependency 'whirly', '~> 0.3'
  s.add_dependency 'paint', '~> 2.3'
end
