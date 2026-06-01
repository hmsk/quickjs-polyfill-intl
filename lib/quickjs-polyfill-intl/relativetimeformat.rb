# frozen_string_literal: true

require 'quickjs'
require_relative 'numberformat'

Quickjs.register_polyfill(
  :polyfill_intl_relativetimeformat,
  source: -> { File.read(File.expand_path('vendor/relativetimeformat-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_relativetimeformat_all,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en relativetimeformat-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
