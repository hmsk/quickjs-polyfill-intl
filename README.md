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

### Standalone (`_all`)

The simplest way: one symbol, no manual dependency management.

```rb
require 'quickjs'
require 'quickjs-polyfill-intl/datetimeformat'

vm = Quickjs::VM.new(features: [:polyfill_intl_datetimeformat_all])
vm.eval_code('new Intl.DateTimeFormat("en", { year: "numeric" }).format(new Date(0))')
# => "1970"
```

### Granular (minimal symbols)

Load each API separately and list them all in `features:` in dependency order. Useful when combining multiple Intl APIs in one VM — each minimal bundle is cached independently, so shared deps aren't recompiled.

```rb
require 'quickjs'
require 'quickjs-polyfill-intl/datetimeformat'  # chains all deps automatically

vm = Quickjs::VM.new(features: [
  :polyfill_intl_getcanonicallocales,
  :polyfill_intl_locale,
  :polyfill_intl_pluralrules,
  :polyfill_intl_numberformat,
  :polyfill_intl_datetimeformat,
])
```

### Load everything

```rb
require 'quickjs-polyfill-intl/all'

vm = Quickjs::VM.new(features: [:polyfill_intl_datetimeformat_all, :polyfill_intl_listformat_all])
```

## Available polyfills

| Require path | Symbol | `_all` symbol | Depends on |
|---|---|---|---|
| `quickjs-polyfill-intl/getcanonicallocales` | `:polyfill_intl_getcanonicallocales` | `:polyfill_intl_getcanonicallocales_all` | — |
| `quickjs-polyfill-intl/locale` | `:polyfill_intl_locale` | `:polyfill_intl_locale_all` | getcanonicallocales |
| `quickjs-polyfill-intl/displaynames` | `:polyfill_intl_displaynames` | `:polyfill_intl_displaynames_all` | locale |
| `quickjs-polyfill-intl/listformat` | `:polyfill_intl_listformat` | `:polyfill_intl_listformat_all` | locale |
| `quickjs-polyfill-intl/pluralrules` | `:polyfill_intl_pluralrules` | `:polyfill_intl_pluralrules_all` | locale |
| `quickjs-polyfill-intl/numberformat` | `:polyfill_intl_numberformat` | `:polyfill_intl_numberformat_all` | pluralrules |
| `quickjs-polyfill-intl/relativetimeformat` | `:polyfill_intl_relativetimeformat` | `:polyfill_intl_relativetimeformat_all` | numberformat |
| `quickjs-polyfill-intl/datetimeformat` | `:polyfill_intl_datetimeformat` | `:polyfill_intl_datetimeformat_all` | numberformat |
| `quickjs-polyfill-intl/supportedvaluesof` | `:polyfill_intl_supportedvaluesof` | `:polyfill_intl_supportedvaluesof_all` | datetimeformat |
| `quickjs-polyfill-intl/durationformat` | `:polyfill_intl_durationformat` | `:polyfill_intl_durationformat_all` | datetimeformat + listformat |

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

Otherwise, [the MIT License, Copyright 2026 by Kengo Hamasaki](/LICENSE).
