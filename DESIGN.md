# Design Notes

## Why a companion gem?

The original `quickjs.rb` embedded the FormatJS Intl bundle as pre-compiled QuickJS bytecode baked into the `.so` at build time. This had two costs:

- ~2.1 MB of bytecode shipped to every installer, regardless of whether they used Intl at all
- The main gem had to track FormatJS npm packages, version-lock locale data, and run `qjsc` as part of the build

Extracting Intl into a companion gem gives downstreams an explicit opt-in and lets the polyfill versioning evolve independently of the QuickJS C extension. The main gem stays focused on the runtime; this gem focuses on the Intl surface.

## register_polyfill API

This gem depends on `Quickjs.register_polyfill(name, source:, init: nil)` introduced in `quickjs >= 0.19.0`. The API works as follows:

- `name` — a Symbol that consumers pass in `features:` when constructing a VM
- `source:` — a String or Proc returning one; the Proc form defers the file read until a VM actually opts into the feature
- `init:` — optional JS that runs before the source in the same compilation unit

The first VM that enables a given polyfill pays the parse cost (source compiled to QuickJS bytecode on a disposable VM); all subsequent VMs reuse the cached bytecode. The polyfill load bypasses the user VM's `timeout_msec` budget.

All registrations in this gem use the Proc form for `source:` so the JS files are only read when needed.

## Minimal bundles + `_all` convention

Each Intl API ships as two registrations:

**Minimal (`:<name>`)**: the bundle contains only that API's own code — no dependencies embedded. Works correctly only when all dependency symbols also appear in `features:`, in topological order. Useful when loading multiple Intl APIs into one VM; each minimal bundle has its own bytecode cache entry, so shared deps aren't re-parsed.

**Self-contained (`:<name>_all`)**: the bundle concatenates the full dependency chain at source level. One symbol, works standalone. The concatenation happens inside a lazy Proc, so no extra build artifact is needed — the same minimal `.min.js` files serve both paths.

The `_all` suffix was chosen over a `depends_on:` parameter on `register_polyfill` to avoid requiring an API change in the main gem. The companion gem handles dependency wiring entirely at the Ruby layer.

## Ruby require chain

Each `.rb` file `require_relative`s its direct dependency:

```
durationformat → datetimeformat → numberformat → pluralrules → locale → getcanonicallocales
             ↘ listformat ↗
relativetimeformat → numberformat
supportedvaluesof → datetimeformat
displaynames → locale
```

`require 'quickjs-polyfill-intl/datetimeformat'` therefore registers all symbols from `getcanonicallocales` up through `datetimeformat` (both minimal and `_all` variants). Ruby's `require` is idempotent so the chain is safe to traverse multiple times.

`require 'quickjs-polyfill-intl/all'` is a convenience that chains through `durationformat` (the deepest node that covers the main chain + listformat) then adds the remaining independent branches: `displaynames`, `relativetimeformat`, `supportedvaluesof`.

## Symbol naming and constants

All symbols follow `polyfill_intl_<api_name>` / `polyfill_intl_<api_name>_all`. The prefix dates back to `Quickjs::POLYFILL_INTL` (`:feature_polyfill_intl`) in the main gem, before Intl was extracted here; that constant no longer exists upstream, but the naming stuck.

Each symbol is also exposed as a constant under this gem's own `Quickjs::Polyfill::Intl` namespace, following the `CONSTANT = :symbol` shape the main gem uses for `MODULE_STD`, `POLYFILL_FILE` and friends (defined in C, via `rb_define_const` in `r_define_constants`). The constant's value *is* the symbol, so this is purely additive: bare symbols keep working, and the two forms can be mixed in one `features:` list. What the constants buy is a `NameError` on a typo, where a misspelled bare symbol would instead reach `VM.new` as an unregistered feature.

Constants live in `Quickjs::Polyfill::Intl`, not at the top of `Quickjs`, so a companion gem does not plant names in the main gem's namespace — the concern behind this file's original "no constants" rule, which was about the `Quickjs` namespace specifically rather than about constants as such. Names mirror the JS API spelling rather than the symbol's (`DATE_TIME_FORMAT` for `Intl.DateTimeFormat`, not `DATETIMEFORMAT`).

Each constant pair is declared in the same file that registers it, so it exists exactly when its registration does — a granular `require` brings in only the constants it registered, and `register_polyfill` is called with the constant rather than a repeated literal, keeping one source of truth per name.

## JS build tooling

JS sources live in `js/src/` (one file per API, minimal — no deps). Rolldown bundles each into `lib/quickjs-polyfill-intl/vendor/` as an IIFE. The `js/` directory name distinguishes the npm workspace from the Ruby gem content; `vendor/` inside `lib/` mirrors the convention used in the main gem (`ext/quickjsrb/vendor/`).

Built files are committed to the repository so consumers don't need Node.js. To rebuild after bumping FormatJS versions: `rake js:build`.

APIs with locale data (`displaynames`, `listformat`, `pluralrules`, `numberformat`, `relativetimeformat`, `datetimeformat`) ship English locale only, matching the scope of the original main-gem bundle. Additional locale support is a future concern for this gem.
