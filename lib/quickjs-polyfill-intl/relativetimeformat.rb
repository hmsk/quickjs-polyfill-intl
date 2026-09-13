# frozen_string_literal: true

require 'quickjs'
require_relative 'numberformat'

module Quickjs
  module Polyfill
    module Intl
      RELATIVE_TIME_FORMAT = :polyfill_intl_relativetimeformat
      RELATIVE_TIME_FORMAT_ALL = :polyfill_intl_relativetimeformat_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::RELATIVE_TIME_FORMAT,
  source: -> { File.read(File.expand_path('vendor/relativetimeformat-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::RELATIVE_TIME_FORMAT_ALL,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en relativetimeformat-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
