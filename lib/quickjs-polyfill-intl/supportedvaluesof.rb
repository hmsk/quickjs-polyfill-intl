# frozen_string_literal: true

require 'quickjs'
require_relative 'datetimeformat'

module Quickjs
  module Polyfill
    module Intl
      SUPPORTED_VALUES_OF = :polyfill_intl_supportedvaluesof
      SUPPORTED_VALUES_OF_ALL = :polyfill_intl_supportedvaluesof_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::SUPPORTED_VALUES_OF,
  source: -> { File.read(File.expand_path('vendor/supportedvaluesof.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::SUPPORTED_VALUES_OF_ALL,
  source: -> {
    %w[getcanonicallocales locale pluralrules-en numberformat-en datetimeformat-en supportedvaluesof].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
