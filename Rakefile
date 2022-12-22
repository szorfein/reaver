# frozen_string_literal: true

require 'rake/testtask'
require File.dirname(__FILE__) + '/lib/harpoon/version'

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
  Dir['harpoon*.gem'].each { |f| File.unlink(f) }
    system('gem build harpoon.gemspec')
    system("gem install harpoon-#{Harpoon::VERSION}.gem")
  end
end

task default: :test
