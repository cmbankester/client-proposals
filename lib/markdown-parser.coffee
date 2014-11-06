libdir = "#{process.cwd()}/lib"
marked = require 'marked'

marked.setOptions
  renderer: require("#{libdir}/renderer")
  gfm: true

module.exports = (md_blob, cb) -> marked md_blob, cb
