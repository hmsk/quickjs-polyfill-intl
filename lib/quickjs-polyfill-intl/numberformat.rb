# frozen_string_literal: true

require 'quickjs'
require_relative 'pluralrules'

module Quickjs
  module Polyfill
    module Intl
      NUMBER_FORMAT = :polyfill_intl_numberformat
      NUMBER_FORMAT_ALL = :polyfill_intl_numberformat_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::NUMBER_FORMAT,
  source: -> { File.read(File.expand_path('vendor/numberformat-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::NUMBER_FORMAT_ALL,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
