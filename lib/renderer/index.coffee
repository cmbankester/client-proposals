marked = require('marked')
renderer = new marked.Renderer()

renderer.heading = require './heading'

# Overridable renderers:
#
# renderer.code = (string code, string language) ->
# renderer.blockquote = (string quote) ->
# renderer.html = (string html) ->
# renderer.heading = (string text, number level) ->
# renderer.hr = () ->
# renderer.list = (string body, boolean ordered) ->
# renderer.listitem = (string text) ->
# renderer.paragraph = (string text) ->
# renderer.table = (string header, string body) ->
# renderer.tablerow = (string content) ->
# renderer.tablecell = (string content, object flags) ->
  # flags: { header: true || false, align: 'center' || 'left' || 'right' }
# renderer.strong = (string text) ->
# renderer.em = (string text) ->
# renderer.codespan = (string code) ->
# renderer.br = () ->
# renderer.del = (string text) ->
# renderer.link = (string href, string title, string text) ->
# renderer.image = (string href, string title, string text) ->



module.exports = renderer
