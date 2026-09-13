# frozen_string_literal: true

require 'quickjs'
require_relative 'locale'

module Quickjs
  module Polyfill
    module Intl
      LIST_FORMAT = :polyfill_intl_listformat
      LIST_FORMAT_ALL = :polyfill_intl_listformat_all
    end
  end
end

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::LIST_FORMAT,
  source: -> { File.read(File.expand_path('vendor/listformat-en.min.js', __dir__)) },
  init: 'globalThis.Intl ||= {};'
)

Quickjs.register_polyfill(
  Quickjs::Polyfill::Intl::LIST_FORMAT_ALL,
  source: -> {
    %w[getcanonicallocales locale listformat-en].map { File.read(File.expand_path("vendor/#{_1}.min.js", __dir__)) }.join("\n")
  },
  init: 'globalThis.Intl ||= {};'
)
