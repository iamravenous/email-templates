which         = require 'which'
{spawn, exec} = require 'child_process'

# Compiles app.coffee and src directory to the .app directory
build = (callback) ->
  options = ['-c','-b', '-o', 'app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0

task 'build', ->
  build -> console.log "app built"