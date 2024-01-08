module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  extend: {
    colors: {
      primary: {
        100: "D2FFFA"
      },
      lemon: {
        100: "FDFF90"
      },
    },
  },
  plugins: [require("daisyui")],
}
