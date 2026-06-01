# frozen_string_literal: true

require 'quickjs'
require_relative 'pluralrules'

Quickjs.register_polyfill(
  :polyfill_intl_numberformat,
  source: -> { File.read(File.expand_path('vendor/numberformat-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_numberformat_all,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
