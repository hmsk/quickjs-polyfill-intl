# frozen_string_literal: true

require 'quickjs'

Quickjs.register_polyfill(
  :polyfill_intl_getcanonicallocales,
  source: -> { File.read(File.expand_path('vendor/getcanonicallocales.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_getcanonicallocales_all,
  source: -> { File.read(File.expand_path('vendor/getcanonicallocales.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)
