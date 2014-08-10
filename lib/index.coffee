logger = require './logger'

discovery = require './discovery'
db        = require './db'
socket    = require './socket'
protocol  = require './protocol'

async     = require 'async'


exports.init = (port, dbPath, language, cb) ->
  logger.info "Initializing PedaMaster on port " + port + "."
  
  async.parallel [
    (cb) ->
      discovery.init port, cb
    , (cb) ->
      db.init dbPath, cb
    , (cb) ->
      socket.init port, cb
    , (cb) ->
      protocol.init socket, language, cb
  ], cb
  
exports.start = ->
  logger.info "Starting PedaMaster."
  socket.start()
  discovery.start()
  logger.info "All Systems running!"

exports.stop = (code) ->
  logger.info "Stopping PedaMaster. Code " + code
  discovery.stop()
  db.stop()
  logger.info "All Systems terminated! Goodbye."
  
  process.exit()
