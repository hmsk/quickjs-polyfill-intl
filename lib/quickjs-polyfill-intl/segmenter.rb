# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

module Quickjs
  module Polyfill
    module Intl
      SEGMENTER = :polyfill_intl_segmenter
      SEGMENTER_ALL = :polyfill_intl_segmenter_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::SEGMENTER,
  source: -> { File.read(File.expand_path('vendor/segmenter.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::SEGMENTER_ALL,
  source: -> {
    %w[getcanonicallocales locale segmenter].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
