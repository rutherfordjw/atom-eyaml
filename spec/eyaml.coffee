{WorkspaceView} = require 'atom'
EyamlEncrypt = require '../lib/eyaml'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "EyamlEncrypt", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('eyaml')

  describe "when the eyaml:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.eyaml')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'eyaml:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.eyaml')).toExist()
        atom.workspaceView.trigger 'eyaml:toggle'
        expect(atom.workspaceView.find('.eyaml')).not.toExist()
