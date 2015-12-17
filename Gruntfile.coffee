module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

  grunt.registerTask "default", ->
    done = @async()

    done new Error "Not implemented!"

    # compile markdown files
    # maybe watch for file changes, then compile them as they change?

  grunt.registerTask "compile", (client, proposal) ->
    done = @async()
    if client? and proposal?
      require('./clients').performOn(client) 'compile-markdown', {proposal: proposal}, (err) ->
        if err then return done err
        done()
    else
      done new Error "You must pass in a client and a proposal (try 'grunt compile:isc:my-isc')"

  grunt.registerTask "client", (client, subtask) ->
    done = @async()
    clients = require './clients'
    if client
      clients.exists client, (err, exists) ->
        if err then return done err
        if exists
          if subtask isnt 'create'
            if subtask
              clients.performOn(client) subtask, done
            else
              clients.queryThenPerformOn(client) 'create-proposal', done
          else
            done new Error "Client #{client} already exists"
        else
          if subtask and subtask isnt 'create'
              clients.queryThenPerformOn(client) 'create', done
          else
            clients.performOn(client) 'create', done
    else
      done new Error "You must pass in a client (try 'grunt client:isc' or 'grunt client:isc:create-proposal')"
