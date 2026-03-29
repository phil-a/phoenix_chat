const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/phoenix_chat_web.ex",
    "../lib/phoenix_chat_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    plugin(function({addBase, theme}) {
      addBase({
        "[type='search']::-webkit-search-decoration": { display: "none" },
        "[type='search']::-webkit-search-cancel-button": { display: "none" },
        "[type='search']::-webkit-search-results-button": { display: "none" },
        "[type='search']::-webkit-search-results-decoration": { display: "none" },
      })
    }),
  ]
}
