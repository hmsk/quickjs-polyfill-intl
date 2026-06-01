# frozen_string_literal: true

require 'quickjs'
require_relative 'datetimeformat'
require_relative 'listformat'

Quickjs.register_polyfill(
  :polyfill_intl_durationformat,
  source: -> { File.read(File.expand_path('vendor/durationformat.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_durationformat_all,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en datetimeformat-en listformat-en durationformat].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
