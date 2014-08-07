discovery = require('./discovery')

exports.init = (port) ->
  console.log("Initializing PedaMaster on port " + port + ".")
  
  discovery.init(port)

exports.start = ->
  console.log("Starting PedaMaster.")
  discovery.start()
