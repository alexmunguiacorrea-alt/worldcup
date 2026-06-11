import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'field-green': '#1d4d2d',
        'field-light': '#2d6d3d',
        'trophy-gold': '#ffd700',
        'trophy-light': '#ffed4e',
      },
    },
  },
  plugins: [],
}
export default config
