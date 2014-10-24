module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

  grunt.registerTask "default", ->
    # compile markdown files
    # maybe watch for file changes, then compile them as they change?

  grunt.registerTask "client", (client, subtask) ->
    done = @async()
    clients = require 'clients'
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
      done new Error "You must pass in a client (try 'grunt client:isc' or 'grunt client:isc:generate-proposal')"
