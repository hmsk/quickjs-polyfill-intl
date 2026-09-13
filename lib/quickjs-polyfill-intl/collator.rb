# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

module Quickjs
  module Polyfill
    module Intl
      COLLATOR = :polyfill_intl_collator
      COLLATOR_ALL = :polyfill_intl_collator_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::COLLATOR,
  source: -> { File.read(File.expand_path('vendor/collator-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::COLLATOR_ALL,
  source: -> {
    %w[getcanonicallocales locale collator-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
