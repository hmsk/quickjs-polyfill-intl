# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test' << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :js do
  desc 'Rebuild the Intl bundle (requires npm)'
  task :build do
    Dir.chdir('js') do
      sh 'npm install'
      sh 'npm run build'
    end
  end
end

task default: :test
