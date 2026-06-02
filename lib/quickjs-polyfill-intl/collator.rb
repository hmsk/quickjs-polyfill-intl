# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

Quickjs.register_polyfill(
  :polyfill_intl_collator,
  source: -> { File.read(File.expand_path('vendor/collator-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_collator_all,
  source: -> {
    %w[getcanonicallocales locale collator-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
