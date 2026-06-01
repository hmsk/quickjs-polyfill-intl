# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

Quickjs.register_polyfill(
  :polyfill_intl_displaynames,
  source: -> { File.read(File.expand_path('vendor/displaynames-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_displaynames_all,
  source: -> {
    %w[getcanonicallocales locale displaynames-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
