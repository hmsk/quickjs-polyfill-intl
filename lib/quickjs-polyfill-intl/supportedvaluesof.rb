# frozen_string_literal: true

require 'quickjs'
require_relative 'datetimeformat'

Quickjs.register_polyfill(
  :polyfill_intl_supportedvaluesof,
  source: -> { File.read(File.expand_path('vendor/supportedvaluesof.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  :polyfill_intl_supportedvaluesof_all,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en datetimeformat-en supportedvaluesof].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
