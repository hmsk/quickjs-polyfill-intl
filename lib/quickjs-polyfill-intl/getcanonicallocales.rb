# frozen_string_literal: true

require 'quickjs'

module Quickjs
  module Polyfill
    module Intl
      GET_CANONICAL_LOCALES = :polyfill_intl_getcanonicallocales
      GET_CANONICAL_LOCALES_ALL = :polyfill_intl_getcanonicallocales_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::GET_CANONICAL_LOCALES,
  source: -> { File.read(File.expand_path('vendor/getcanonicallocales.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::GET_CANONICAL_LOCALES_ALL,
  source: -> { File.read(File.expand_path('vendor/getcanonicallocales.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)
