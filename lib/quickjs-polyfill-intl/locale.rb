# frozen_string_literal: true

require 'quickjs'
require_relative 'getcanonicallocales'

Quickjs.register_polyfill(
  :polyfill_intl_locale,
  source: -> { File.read(File.expand_path('vendor/locale.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_locale_all,
  source: -> {
    %w[getcanonicallocales locale].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
