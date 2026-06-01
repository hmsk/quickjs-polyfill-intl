# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

Quickjs.register_polyfill(
  :polyfill_intl_pluralrules,
  source: -> { File.read(File.expand_path('vendor/pluralrules-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_pluralrules_all,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
