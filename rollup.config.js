import resolve from "@rollup/plugin-node-resolve"
import { terser } from "rollup-plugin-terser"
import pkg from "./package.json"

export default [
  {
    input: pkg.module,
    output: {
      file: pkg.main,
      format: "es",
      inlineDynamicImports: true
    },
    plugins: [
      resolve(),
      terser({
        mangle: false,
        compress: false,
        format: {
          beautify: true,
          indent_level: 2
        }
      })
    ]
  },

  {
    input: pkg.module,
    output: {
      file: "app/assets/javascripts/turbo.min.js",
      format: "es",
      inlineDynamicImports: true
    },
    plugins: [
      resolve(),
      terser({
        mangle: true,
        compress: true
      })
    ]
  }
]
