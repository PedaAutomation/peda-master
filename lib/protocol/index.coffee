logger = require '../logger'

Slave = require './slave'

slaves = []

handleSlaveInput = (data) ->
  logger.info "Incoming Input from #{@name}: #{data.command}"
  
  for id of slaves
    slaves[id].handleCommand data
    
handleSlaveOutputForward = (data) ->
  logger.info "Output Forward requested: ", data
  
  if (not data.targetDevice) and (not data.targetCapability)
    for id of slaves
      slave = slaves[id]
      if slave.outputCapabilities.length > 0
        slave.handleOutput data
  else if data.targetDevice and not data.targetCapability
    for id of slaves
      slave = slaves[id]
      if slave.name == data.targetDevice
        slave.handleOutput data
  else if not data.target and data.targetCapability
    data.data.targetCapability = data.targetCapability
    
    for id of slaves
      if slave.hasOutputCapability data.targetCapability
        slave.handleOutput data

exports.init = (socket, cb) ->
  
  logger.info "Initializing Protocol."
  
  
  socket.on 'connection', (data) ->
    slave = new Slave(data.socket)
    
    slave.on 'input', handleSlaveInput
    slave.on 'outputForward', handleSlaveOutputForward
    
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
