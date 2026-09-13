# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

module Quickjs
  module Polyfill
    module Intl
      DISPLAY_NAMES = :polyfill_intl_displaynames
      DISPLAY_NAMES_ALL = :polyfill_intl_displaynames_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::DISPLAY_NAMES,
  source: -> { File.read(File.expand_path('vendor/displaynames-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::DISPLAY_NAMES_ALL,
  source: -> {
    %w[getcanonicallocales locale displaynames-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
