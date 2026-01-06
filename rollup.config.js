import resolve from "@rollup/plugin-node-resolve"
import { terser } from "rollup-plugin-terser"
import pkg from "./package.json"

export default [
  {
    input: pkg.module,
    output: {
      file: pkg.main,
      format: "esm",
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
      format: "esm",
      inlineDynamicImports: true,
      sourcemap: true
    },
    plugins: [
      resolve(),
      terser({
        mangle: true,
        compress: true
      })
    ]
  },

  // Offline bundle
  {
    input: "app/javascript/turbo/offline.js",
    output: {
      file: "app/assets/javascripts/turbo-offline.js",
      format: "esm",
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
    input: "app/javascript/turbo/offline.js",
    output: {
      file: "app/assets/javascripts/turbo-offline.min.js",
      format: "esm",
      inlineDynamicImports: true,
      sourcemap: true
    },
    plugins: [
      resolve(),
      terser({
        mangle: true,
        compress: true
      })
    ]
  },

  // Offline UMD bundle (for service workers using importScripts)
  {
    input: "app/javascript/turbo/offline.js",
    output: {
      name: "TurboOffline",
      file: "app/assets/javascripts/turbo-offline-umd.js",
      format: "umd",
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
    input: "app/javascript/turbo/offline.js",
    output: {
      name: "TurboOffline",
      file: "app/assets/javascripts/turbo-offline-umd.min.js",
      format: "umd",
      inlineDynamicImports: true,
      sourcemap: true
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
