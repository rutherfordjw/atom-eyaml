{spawn} = require 'child_process'

module.exports =
  activate: ->
    atom.workspaceView.command "eyaml:encrypt", => @encrypt()
    atom.workspaceView.command "eyaml:decrypt", => @decrypt()
    atom.workspaceView.command "eyaml:md5hash", => @md5hash()

  encrypt: ->
    selection = atom.workspace.getActiveEditor().getSelection()

    cmd = spawn('eyaml', ['encrypt', '-s', selection.getText()])
    cmd.stderr.on 'data', (data) ->
      console.log data.toString()
    cmd.stdout.on 'data', (data) ->
      encrypted_string = data.toString().match(/ENC\[PKCS7\,[\w+/\s]+\s+[\w+/\s]+\]/)
      selection.insertText(encrypted_string[0].trim())

  decrypt: ->
    selection = atom.workspace.getActiveEditor().getSelection()

    selected_text = selection.getText().replace(/\s+/g, '')
    console.log selected_text

    cmd = spawn('eyaml', ['decrypt', '-s', selected_text])
    cmd.stderr.on 'data', (data) ->
      console.log data.toString()
    cmd.stdout.on 'data', (data) ->
      selection.insertText(data.toString().trim())

  md5hash: ->
    selection = atom.workspace.getActiveEditor().getSelection()

    cmd = spawn('openssl', [ 'passwd', '-1', selection.getText() ])
    cmd.stderr.on 'data', (data) ->
      console.log data.toString()
    cmd.stdout.on 'data', (data) ->
      selection.insertText(data.toString().trim())
