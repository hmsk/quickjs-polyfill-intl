# quickjs-polyfill-intl

FormatJS Intl polyfills for [quickjs.rb](https://github.com/hmsk/quickjs.rb) — granular, dependency-aware, English locale.

[![Gem Version](https://img.shields.io/gem/v/quickjs-polyfill-intl?style=for-the-badge)](https://rubygems.org/gems/quickjs-polyfill-intl) [![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/hmsk/quickjs-polyfill-intl/ci.yml?style=for-the-badge)](https://github.com/hmsk/quickjs-polyfill-intl/actions/workflows/ci.yml)

## Installation

```
gem install quickjs-polyfill-intl
```

```rb
gem 'quickjs-polyfill-intl'
```

Requires `quickjs >= 0.19.0`.

## Usage

Each Intl API has its own require path. Requiring a path registers two feature symbols:

- **`:<name>`** — the API's own bundle only; you must include all dependencies in `features:` yourself (in order).
- **`:<name>_all`** — a self-contained bundle with all dependencies included; works standalone.

Every symbol is also exposed as a constant under `Quickjs::Polyfill::Intl`, which is the preferred way to reference them — a misspelling raises `NameError` instead of silently passing an unregistered symbol. The constant's value *is* the symbol, so the two forms are interchangeable and can be mixed freely in one `features:` list.

```rb
Quickjs::Polyfill::Intl::DATE_TIME_FORMAT      # => :polyfill_intl_datetimeformat
Quickjs::Polyfill::Intl::DATE_TIME_FORMAT_ALL  # => :polyfill_intl_datetimeformat_all
```

### Standalone (`_all`)

The simplest way: one symbol, no manual dependency management.

```rb
require 'quickjs'
require 'quickjs-polyfill-intl/datetimeformat'

vm = Quickjs::VM.new(features: [Quickjs::Polyfill::Intl::DATE_TIME_FORMAT_ALL])
vm.eval_code('new Intl.DateTimeFormat("en", { year: "numeric" }).format(new Date(0))')
# => "1970"
```

### Granular (minimal symbols)

Load each API separately and list them all in `features:` in dependency order. Useful when combining multiple Intl APIs in one VM — each minimal bundle is cached independently, so shared deps aren't recompiled.

```rb
require 'quickjs'
require 'quickjs-polyfill-intl/datetimeformat'  # chains all deps automatically

Intl = Quickjs::Polyfill::Intl

vm = Quickjs::VM.new(features: [
  Intl::GET_CANONICAL_LOCALES,
  Intl::LOCALE,
  Intl::PLURAL_RULES,
  Intl::NUMBER_FORMAT,
  Intl::DATE_TIME_FORMAT,
])
```

### Load everything

```rb
require 'quickjs-polyfill-intl/all'

Intl = Quickjs::Polyfill::Intl

vm = Quickjs::VM.new(features: [Intl::DATE_TIME_FORMAT_ALL, Intl::LIST_FORMAT_ALL])
```

## Available polyfills

| Require path | Constant (under `Quickjs::Polyfill::Intl`) | Symbol | Depends on |
|---|---|---|---|
| `quickjs-polyfill-intl/getcanonicallocales` | `GET_CANONICAL_LOCALES` / `GET_CANONICAL_LOCALES_ALL` | `:polyfill_intl_getcanonicallocales` / `…_all` | — |
| `quickjs-polyfill-intl/locale` | `LOCALE` / `LOCALE_ALL` | `:polyfill_intl_locale` / `…_all` | getcanonicallocales |
| `quickjs-polyfill-intl/collator` | `COLLATOR` / `COLLATOR_ALL` | `:polyfill_intl_collator` / `…_all` | locale |
| `quickjs-polyfill-intl/displaynames` | `DISPLAY_NAMES` / `DISPLAY_NAMES_ALL` | `:polyfill_intl_displaynames` / `…_all` | locale |
| `quickjs-polyfill-intl/listformat` | `LIST_FORMAT` / `LIST_FORMAT_ALL` | `:polyfill_intl_listformat` / `…_all` | locale |
| `quickjs-polyfill-intl/pluralrules` | `PLURAL_RULES` / `PLURAL_RULES_ALL` | `:polyfill_intl_pluralrules` / `…_all` | locale |
| `quickjs-polyfill-intl/segmenter` | `SEGMENTER` / `SEGMENTER_ALL` | `:polyfill_intl_segmenter` / `…_all` | locale |
| `quickjs-polyfill-intl/numberformat` | `NUMBER_FORMAT` / `NUMBER_FORMAT_ALL` | `:polyfill_intl_numberformat` / `…_all` | pluralrules |
| `quickjs-polyfill-intl/relativetimeformat` | `RELATIVE_TIME_FORMAT` / `RELATIVE_TIME_FORMAT_ALL` | `:polyfill_intl_relativetimeformat` / `…_all` | numberformat |
| `quickjs-polyfill-intl/datetimeformat` | `DATE_TIME_FORMAT` / `DATE_TIME_FORMAT_ALL` | `:polyfill_intl_datetimeformat` / `…_all` | numberformat |
| `quickjs-polyfill-intl/supportedvaluesof` | `SUPPORTED_VALUES_OF` / `SUPPORTED_VALUES_OF_ALL` | `:polyfill_intl_supportedvaluesof` / `…_all` | datetimeformat |
| `quickjs-polyfill-intl/durationformat` | `DURATION_FORMAT` / `DURATION_FORMAT_ALL` | `:polyfill_intl_durationformat` / `…_all` | datetimeformat + listformat |

Requiring a path also requires its full dependency chain, so all dependent symbols are registered automatically.

## Building the JS bundles

The minified bundles in `lib/quickjs-polyfill-intl/vendor/` are committed to the repo. To rebuild after updating FormatJS package versions:

```
rake js:build
```

Requires Node.js and npm.

## Acknowledgements

- [@ursm](https://github.com/ursm) — for the `Quickjs.register_polyfill` API that makes this gem possible

## License

- `lib/quickjs-polyfill-intl/vendor/` ([bundled and minified from `js/`](https://github.com/hmsk/quickjs-polyfill-intl/tree/main/js))
  - MIT License Copyright (c) 2022 FormatJS
    - [@formatjs/intl-supportedvaluesof](https://github.com/formatjs/formatjs/blob/main/packages/intl-supportedvaluesof/LICENSE.md)
    - [@formatjs/intl-segmenter](https://github.com/formatjs/formatjs/blob/main/packages/intl-segmenter/LICENSE.md)
  - MIT License Copyright (c) 2023 FormatJS
    - [@formatjs/intl-getcanonicallocales](https://github.com/formatjs/formatjs/blob/main/packages/intl-getcanonicallocales/LICENSE.md)
    - [@formatjs/intl-locale](https://github.com/formatjs/formatjs/blob/main/packages/intl-locale/LICENSE.md)
    - [@formatjs/intl-displaynames](https://github.com/formatjs/formatjs/blob/main/packages/intl-displaynames/LICENSE.md)
    - [@formatjs/intl-listformat](https://github.com/formatjs/formatjs/blob/main/packages/intl-listformat/LICENSE.md)
    - [@formatjs/intl-pluralrules](https://github.com/formatjs/formatjs/blob/main/packages/intl-pluralrules/LICENSE.md)
    - [@formatjs/intl-numberformat](https://github.com/formatjs/formatjs/blob/main/packages/intl-numberformat/LICENSE.md)
    - [@formatjs/intl-relativetimeformat](https://github.com/formatjs/formatjs/blob/main/packages/intl-relativetimeformat/LICENSE.md)
    - [@formatjs/intl-datetimeformat](https://github.com/formatjs/formatjs/blob/main/packages/intl-datetimeformat/LICENSE.md)
    - [@formatjs/intl-durationformat](https://github.com/formatjs/formatjs/blob/main/packages/intl-durationformat/LICENSE.md)
    - [@formatjs/fast-memoize](https://github.com/formatjs/formatjs/blob/main/packages/fast-memoize/LICENSE.md)
    - [@formatjs/intl-localematcher](https://github.com/formatjs/formatjs/blob/main/packages/intl-localematcher/LICENSE.md)
  - MIT License Copyright (c) 2026 FormatJS
    - [@formatjs/bigdecimal](https://github.com/formatjs/formatjs/blob/main/packages/bigdecimal/LICENSE.md)
    - [@formatjs/intl-collator](https://github.com/formatjs/formatjs/blob/main/packages/intl-collator/LICENSE.md)

Otherwise, [the MIT License, Copyright 2026 by Kengo Hamasaki](/LICENSE).
