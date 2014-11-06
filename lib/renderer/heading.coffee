module.exports = (text, level) ->
  escapedText = text.toLowerCase().replace(/[^\w]+/g, '-')
  "<h#{level} id='#{escapedText}'>" +
    text +
  "</h#{level}>"
