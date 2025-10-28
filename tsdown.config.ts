import { defineConfig } from 'tsdown'

export default defineConfig({
  entry: ['./src/index.ts'],
  format: ['esm'],
  platform: 'browser',
  noExternal: ['postal-mime'],
  minify: false,
  treeshake: true,
})