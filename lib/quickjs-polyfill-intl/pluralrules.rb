# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

module Quickjs
  module Polyfill
    module Intl
      PLURAL_RULES = :polyfill_intl_pluralrules
      PLURAL_RULES_ALL = :polyfill_intl_pluralrules_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::PLURAL_RULES,
  source: -> { File.read(File.expand_path('vendor/pluralrules-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::PLURAL_RULES_ALL,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
