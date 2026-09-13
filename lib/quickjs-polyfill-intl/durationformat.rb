# frozen_string_literal: true

require 'quickjs'
require_relative 'datetimeformat'
require_relative 'listformat'

module Quickjs
  module Polyfill
    module Intl
      DURATION_FORMAT = :polyfill_intl_durationformat
      DURATION_FORMAT_ALL = :polyfill_intl_durationformat_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::DURATION_FORMAT,
  source: -> { File.read(File.expand_path('vendor/durationformat.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::DURATION_FORMAT_ALL,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en datetimeformat-en listformat-en durationformat].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
