# frozen_string_literal: true

require 'quickjs'
require_relative 'numberformat'

Quickjs.register_polyfill(
  :polyfill_intl_datetimeformat,
  source: -> { File.read(File.expand_path('vendor/datetimeformat-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_datetimeformat_all,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en datetimeformat-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
