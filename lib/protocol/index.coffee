logger = require '../logger'

Slave = require './slave'

slaves = []

exports.init = (socket, cb) ->
  
  logger.info "Initializing Protocol."
  
  
  socket.on 'connection', (data) ->
    slaves[data.id] = new Slave(data.ws)
    
  socket.on 'disconnect', (data) ->
    delete slaves[slaves.id]
    
  socket.on 'message', (data) ->
    slaves[data.id].processMessage(data.message)
    
    
  logger.info "Protocol initialized and ready to rumble."
  cb()
