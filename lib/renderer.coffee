marked = require('marked')
renderer = new marked.Renderer()

renderer.heading = (text, level) ->
  escapedText = text.toLowerCase().replace(/[^\w]+/g, '-')
  "<h#{level} id='#{escapedText}'>" +
    "#{text}" +
  "</h#{level}>"

module.exports = renderer
