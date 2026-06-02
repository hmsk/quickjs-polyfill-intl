# frozen_string_literal: true

require_relative 'lib/quickjs-polyfill-intl/version'

Gem::Specification.new do |spec|
  spec.name = 'quickjs-polyfill-intl'
  spec.version = Quickjs::Polyfill::Intl::VERSION
  spec.authors = ['hmsk']
  spec.email = ['k.hamasaki@gmail.com']

  spec.summary = 'FormatJS Intl polyfill for quickjs.rb'
  spec.description = 'Ships the FormatJS Intl bundle (en locale) as a companion polyfill for quickjs.rb'
  spec.homepage = 'https://github.com/hmsk/quickjs-polyfill-intl'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      f == File.basename(__FILE__) || f.start_with?(*%w[bin/ test/ .git .github Gemfile polyfills/])
    end
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'quickjs', '>= 0.19.0.pre1'
end
