logger = require '../logger'

Slave = require './slave'

slaves = []

exports.init = (socket, cb) ->
  
  logger.info "Initializing Protocol."
  
  
  socket.on 'connection', (data) ->
    slaves[data.id] = new Slave(data.socket)
    
  socket.on 'disconnect', (data) ->
    delete slaves[slaves.id]
    
  socket.on 'message', (data) ->
    try 
      slaves[data.id].processMessage(JSON.parse(data.message))
    catch e
      console.log e
      logger.log 'error', "Received invalid message: " + data.message, e
    
  logger.info "Protocol initialized and ready to rumble."
  cb()
