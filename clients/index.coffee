fs = require 'fs'
ff = require 'ff'
path = require 'path'
{existsInClientsDir, getInput} = require "#{process.cwd()}/utils"

client_tasks =
  'create': (client, cb) ->
    (f = ff()).next ->
      fs.mkdir path.join("clients", client), f.wait()

    f.next ->
      getInput "Client name: (#{client}) ", f.slotPlain()

    f.next (client_name) ->
      f.pass client_name
      getInput "Primary contact: ", f.slotPlain()

    f.next (client_name, primary_contact) ->
      client_object =
        'client-name': (client_name or client)
        'primary-contact': primary_contact

      # Client Metadata File
      file_path = path.join('clients', client, 'client.json')
      file_content = "module.exports = #{JSON.stringify client_object, null, 2}"
      fs.writeFile file_path, file_content, f.wait()

    f.onComplete (err) ->
      if err then return cb err
      console.log "Client #{client} created"
      queryThenPerformOn(client) 'create-proposal', cb

  'create-proposal': (client, cb) ->
    questions = ['Name the proposal', 'Author name', 'Send-by date (iso)']
    answers = []

    getProposalInfo = (index, cb) ->
      if question = questions[index]
        getInput question, (stuff) ->
          answers.push stuff
          getProposalInfo index + 1, cb
      else
        cb(answers)

    getProposalInfo 0, ([proposal, author, send_by]) ->
      proposal_path = path.join(client, proposal.toLowerCase().split(' ').join('-'))
      existsInClientsDir proposal_path, is_dir: true, (err, exists) ->
        if err then return cb err
        if exists
          cb new Error "Proposal #{proposal} already exists for client #{client}"
        else
          proposal_path =  path.join('clients', proposal_path)
          fs.mkdir proposal_path, (err) ->
            if err then return cb err

            # MD File
            md_file_path = path.join(proposal_path, 'proposal.md')
            md_content = "# #{proposal} #"

            # Proposal Metadata File (would be awesome if we could use MD metadata here...)
            proposal_metadata =
              'author': author #TODO Current user (from git?)
              'proposal-name': proposal
              'send-by': send_by
            info_file_path = path.join(proposal_path, 'proposal-info.json')
            info_file_content = "module.exports = #{JSON.stringify proposal_metadata, null, 2}"

            fs.writeFile md_file_path, md_content, (err) ->
              if err then return cb err
              console.log "Created proposal #{proposal} for client #{client} in file:\n#{path.join(process.cwd(), md_file_path)}"
              fs.writeFile info_file_path, info_file_content, (err) ->
                if err then return cb err
                cb null

performOn = (client) -> (task_name, cb) ->
  if task = client_tasks[task_name]
    task client, cb
  else
    cb new Error "Unable to process #{task_name}: task does not exist."

queryThenPerformOn = (client) -> (subtask, cb) ->
  getInput "Do you want to run the #{subtask} task for #{client}?", yn: true, (confirmed) ->
    if confirmed
      performOn(client) subtask, cb
    else
      console.log "Ok, nothing done"
      cb null

module.exports =
  exists: (client_name, cb) -> existsInClientsDir(client_name, is_dir: true, cb)
  performOn: performOn
  queryThenPerformOn: queryThenPerformOn
