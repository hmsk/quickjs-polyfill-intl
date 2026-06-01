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

## Symbol naming

All symbols follow `polyfill_intl_<api_name>` / `polyfill_intl_<api_name>_all`. The prefix matches the convention established by `Quickjs::POLYFILL_INTL` (`:feature_polyfill_intl`) in the main gem. No constants are defined in the `Quickjs` namespace from this gem — consumers use the symbols directly or define their own constants.

## JS build tooling

JS sources live in `js/src/` (one file per API, minimal — no deps). Rolldown bundles each into `lib/quickjs-polyfill-intl/vendor/` as an IIFE. The `js/` directory name distinguishes the npm workspace from the Ruby gem content; `vendor/` inside `lib/` mirrors the convention used in the main gem (`ext/quickjsrb/vendor/`).

Built files are committed to the repository so consumers don't need Node.js. To rebuild after bumping FormatJS versions: `rake js:build`.

APIs with locale data (`displaynames`, `listformat`, `pluralrules`, `numberformat`, `relativetimeformat`, `datetimeformat`) ship English locale only, matching the scope of the original main-gem bundle. Additional locale support is a future concern for this gem.
