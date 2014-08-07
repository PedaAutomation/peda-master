logger = require '../logger'

ws           = require 'ws'
EventEmitter = require('events').EventEmitter
util         = require 'util'
uuid         = require 'node-uuid'


WebSocketServer = ws.Server


class Socket extends EventEmitter
  
  constructor: ->
    @connections = []
    
  _connectionHandler: (ws) ->
    ws.id = uuid.v4()
    @connections[ws.id] = ws
    
    this.emit 'connection', { socket: ws, id: ws.id }
    
    self = this
    
    ws.on 'message', (m) ->
      self._messageHandler(ws, m)
    
    ws.on 'close', ->
      self._disconnectionHandler ws
      
  _disconnectionHandler: (ws) ->
    @emit 'disconnect', { socket: ws, id: ws.id }
    @connections = @connections.splice(@connections.indexOf(ws), 1)

  _messageHandler = (ws, message) ->
    @emit 'message', { socket: ws, message: message }

  init: (port, cb) -> 
    
    self = this
      
    logger.info "Initializing WebSocket on port " + port + "."
    
    @wss = new WebSocketServer({ port: port }, () ->
      logger.info "WebSocket initiialized and started."
      cb()
    );
    
    @wss.on 'connection', (ws) ->
      self._connectionHandler(ws)
    
  start: ->
    logger.info "WebSocket server running."
    
    
module.exports = new Socket();
