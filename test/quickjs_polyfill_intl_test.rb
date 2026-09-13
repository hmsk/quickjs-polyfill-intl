# frozen_string_literal: true

require_relative 'test_helper'
require 'quickjs-polyfill-intl/all'

describe 'granular features (_all variants — standalone)' do
  it 'getcanonicallocales' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_getcanonicallocales_all])
    _(vm.eval_code('Intl.getCanonicalLocales("en-us")[0]')).must_equal 'en-US'
  end

  it 'locale' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_locale_all])
    _(vm.eval_code('new Intl.Locale("en-US").language')).must_equal 'en'
  end

  it 'displaynames' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_displaynames_all])
    _(vm.eval_code('new Intl.DisplayNames("en", { type: "language" }).of("fr")')).must_equal 'French'
  end

  it 'listformat' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_listformat_all])
    _(vm.eval_code('new Intl.ListFormat("en").format(["a", "b", "c"])')).must_equal 'a, b, and c'
  end

  it 'pluralrules' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_pluralrules_all])
    _(vm.eval_code('new Intl.PluralRules("en").select(1)')).must_equal 'one'
  end

  it 'numberformat' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_numberformat_all])
    _(vm.eval_code('new Intl.NumberFormat("en", { style: "currency", currency: "USD" }).format(1234.5)')).must_equal '$1,234.50'
  end

  it 'relativetimeformat' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_relativetimeformat_all])
    _(vm.eval_code('new Intl.RelativeTimeFormat("en").format(-1, "day")')).must_equal '1 day ago'
  end

  it 'datetimeformat' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_datetimeformat_all])
    _(vm.eval_code('new Intl.DateTimeFormat("en", { year: "numeric" }).format(new Date(0))')).must_equal '1970'
  end

  it 'supportedvaluesof' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_supportedvaluesof_all], timeout_msec: 10_000)
    _(vm.eval_code('Intl.supportedValuesOf("currency").includes("USD")')).must_equal true
  end

  it 'durationformat' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_durationformat_all])
    _(vm.eval_code('new Intl.DurationFormat("en").format({ hours: 1, minutes: 30 })')).must_equal '1 hr, 30 min'
  end

  it 'collator' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_collator_all])
    _(vm.eval_code('["banana", "apple", "cherry"].sort(new Intl.Collator("en").compare)')).must_equal %w[apple banana cherry]
  end

  it 'segmenter' do
    vm = Quickjs::VM.new(features: [:polyfill_intl_segmenter_all])
    _(vm.eval_code('[...new Intl.Segmenter("en", { granularity: "word" }).segment("Hello world")].map(s => s.segment)'))
      .must_equal ['Hello', ' ', 'world']
  end
end

describe 'minimal features (deps provided in order)' do
  it 'loads all minimal symbols when features include the full dep chain' do
    features = %i[
      polyfill_intl_getcanonicallocales
      polyfill_intl_locale
      polyfill_intl_collator
      polyfill_intl_segmenter
      polyfill_intl_listformat
      polyfill_intl_pluralrules
      polyfill_intl_numberformat
      polyfill_intl_datetimeformat
      polyfill_intl_displaynames
      polyfill_intl_relativetimeformat
      polyfill_intl_supportedvaluesof
      polyfill_intl_durationformat
    ]
    vm = Quickjs::VM.new(features: features)
    _(vm.eval_code('new Intl.DurationFormat("en").format({ hours: 1, minutes: 30 })')).must_equal '1 hr, 30 min'
  end
end

describe 'not applied when feature not enabled' do
  it 'leaves Intl undefined' do
    _(Quickjs::VM.new.eval_code('typeof Intl')).must_equal 'undefined'
  end
end

describe 'constants' do
  NS = Quickjs::Polyfill::Intl

  it 'exposes every registered symbol as a constant pair' do
    {
      NS::GET_CANONICAL_LOCALES => :polyfill_intl_getcanonicallocales,
      NS::LOCALE => :polyfill_intl_locale,
      NS::COLLATOR => :polyfill_intl_collator,
      NS::DISPLAY_NAMES => :polyfill_intl_displaynames,
      NS::LIST_FORMAT => :polyfill_intl_listformat,
      NS::PLURAL_RULES => :polyfill_intl_pluralrules,
      NS::SEGMENTER => :polyfill_intl_segmenter,
      NS::NUMBER_FORMAT => :polyfill_intl_numberformat,
      NS::RELATIVE_TIME_FORMAT => :polyfill_intl_relativetimeformat,
      NS::DATE_TIME_FORMAT => :polyfill_intl_datetimeformat,
      NS::SUPPORTED_VALUES_OF => :polyfill_intl_supportedvaluesof,
      NS::DURATION_FORMAT => :polyfill_intl_durationformat
    }.each do |const, symbol|
      _(const).must_equal symbol
    end
  end

  it 'pairs each constant with its _all variant' do
    _(NS::DATE_TIME_FORMAT_ALL).must_equal :polyfill_intl_datetimeformat_all
    _(NS::DURATION_FORMAT_ALL).must_equal :polyfill_intl_durationformat_all
    _(NS::GET_CANONICAL_LOCALES_ALL).must_equal :polyfill_intl_getcanonicallocales_all
  end

  it 'works when passed to features:' do
    vm = Quickjs::VM.new(features: [NS::DATE_TIME_FORMAT_ALL])
    _(vm.eval_code('new Intl.DateTimeFormat("en", { dateStyle: "long" }).format(new Date(0))'))
      .must_equal 'January 1, 1970'
  end

  it 'interoperates with bare symbols in the same features list' do
    vm = Quickjs::VM.new(features: [NS::GET_CANONICAL_LOCALES, :polyfill_intl_locale, NS::PLURAL_RULES])
    _(vm.eval_code('new Intl.PluralRules("en").select(1)')).must_equal 'one'
  end

  it 'raises NameError on a misspelled constant' do
    _(proc { NS::DATETIMEFORMAT }).must_raise NameError
  end
end
