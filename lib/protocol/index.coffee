logger = require '../logger'

Slave = require './slave'

slaves = []

handleSlaveInput = (data) ->
  logger.info "Incoming Input from #{@name}: #{data.command}"
  
  for id of slaves
    slaves[id].handleCommand data


exports.init = (socket, cb) ->
  
  logger.info "Initializing Protocol."
  
  
  socket.on 'connection', (data) ->
    slave = new Slave(data.socket)
    slave.on 'input', handleSlaveInput
    
    slaves[data.id] = slave
    
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
