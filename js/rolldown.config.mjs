import { defineConfig } from "rolldown";

const output = (name) => ({
  file: `../lib/quickjs-polyfill-intl/vendor/${name}.min.js`,
  format: "iife",
  minify: true,
});

export default [
  defineConfig({ input: "src/getcanonicallocales.js",    output: output("getcanonicallocales") }),
  defineConfig({ input: "src/locale.js",                 output: output("locale") }),
  defineConfig({ input: "src/collator-en.js",            output: output("collator-en") }),
  defineConfig({ input: "src/displaynames-en.js",        output: output("displaynames-en") }),
  defineConfig({ input: "src/listformat-en.js",          output: output("listformat-en") }),
  defineConfig({ input: "src/pluralrules-en.js",         output: output("pluralrules-en") }),
  defineConfig({ input: "src/numberformat-en.js",        output: output("numberformat-en") }),
  defineConfig({ input: "src/relativetimeformat-en.js",  output: output("relativetimeformat-en") }),
  defineConfig({ input: "src/datetimeformat-en.js",      output: output("datetimeformat-en") }),
  defineConfig({ input: "src/supportedvaluesof.js",      output: output("supportedvaluesof") }),
  defineConfig({ input: "src/durationformat.js",         output: output("durationformat") }),
];
