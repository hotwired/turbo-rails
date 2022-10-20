import resolve from "@rollup/plugin-node-resolve"
import typescript from "@rollup/plugin-typescript"
import { terser } from "rollup-plugin-terser"
import pkg from "./package.json"

export default [
  {
    input: "app/javascript/turbo/index.ts",
    output: {
      file: pkg.main,
      format: "es",
      inlineDynamicImports: true
    },
    plugins: [
      resolve(),
      typescript(),
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
    input: "app/javascript/turbo/index.ts",
    output: {
      file: "app/assets/javascripts/turbo.min.js",
      format: "es",
      inlineDynamicImports: true,
      sourcemap: true
    },
    plugins: [
      resolve(),
      typescript(),
      terser({
        mangle: true,
        compress: true
      })
    ]
  }
]
