fs = require 'fs'
path = require 'path'
readline = require 'readline'

module.exports =
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
