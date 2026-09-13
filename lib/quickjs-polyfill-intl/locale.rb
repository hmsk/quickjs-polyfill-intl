# frozen_string_literal: true

require 'quickjs'
require_relative 'getcanonicallocales'

module Quickjs
  module Polyfill
    module Intl
      LOCALE = :polyfill_intl_locale
      LOCALE_ALL = :polyfill_intl_locale_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::LOCALE,
  source: -> { File.read(File.expand_path('vendor/locale.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::LOCALE_ALL,
  source: -> {
    %w[getcanonicallocales locale].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
