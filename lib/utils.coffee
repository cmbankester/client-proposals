fs = require 'fs'
path = require 'path'
readline = require 'readline'
phantom = require 'phantom'

module.exports =
  convertHTMLToPdfAndPlaceAtPath: (html, path_name, cb) ->
    phantom.create (ph) ->
      ph.createPage (page) ->
        page.set 'content', html
        page.render path.join('clients', path_name), ->
          ph.exit()
          cb(null)
  # headerFromMarkdown: (markdown, opts, cb) ->
  #   if 'function' is typeof opts
  #     cb = opts
  #     opts = {}
  #

  replaceFileInClientsDir: (path_name, file_content, opts, cb) ->
    if 'function' is typeof opts
      cb = opts
      opts = {}
    fs.writeFile path.join('clients', path_name), file_content, cb

  getFileInClientsDir: (path_name, opts, cb) ->
    if 'function' is typeof opts
      cb = opts
      opts = {}
    fs.readFile path.join('clients', path_name), cb

  existsInClientsDir: (path_name, opts, cb) ->
    if 'function' is typeof opts
      cb = opts
      opts = {}
    fs.stat path.join('clients', path_name), (err, stat) ->
      if err
        if err.message[0..5] is "ENOENT"
          return cb null, false
        else
          return cb err
      if opts.is_dir
        return cb null, stat.isDirectory()
      else
        return cb null, true

  getInput: (message, opts, cb) ->
    if 'function' is typeof opts
      cb = opts
      opts = {}
    int = readline.createInterface input: process.stdin, output: process.stdout
    int.question "#{message} #{if opts.yn then '(y/n) ' else ''}", (answer) ->
      int.close()
      answer = (answer.toLowerCase() in ['y', 'yes']) if opts.yn
      cb answer
