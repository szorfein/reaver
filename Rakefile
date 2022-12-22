# frozen_string_literal: true

require 'rake/testtask'
require File.dirname(__FILE__) + '/lib/reaver/version'

# run rake
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

# Usage: rake gem:build
namespace :gem do
  desc 'build the gem'
  task :build do
  Dir['reaver*.gem'].each { |f| File.unlink(f) }
    system('gem build reaver.gemspec')
    system("gem install reaver-#{Reaver::VERSION}.gem")
  end
end

task default: :test
