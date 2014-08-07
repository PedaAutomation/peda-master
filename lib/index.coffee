logger = require './logger'

discovery = require './discovery'
db        = require './db'
socket    = require './socket'

async     = require 'async'


exports.init = (port, dbPath, cb) ->
  logger.info "Initializing PedaMaster on port " + port + "."
  
  async.parallel [
    (cb) ->
      discovery.init port, cb
    , (cb) ->
      db.init dbPath, cb
    , (cb) ->
      socket.init port, cb
  ], cb
  
exports.start = ->
  logger.info "Starting PedaMaster."
  socket.start()
  discovery.start()
  logger.info "All System running!"

exports.stop = (code) ->
  logger.info "Stopping PedaMaster. Code " + code
  discovery.stop()
  db.stop()
  logger.info "All Systems terminated! Goodbye."
  
  process.exit()
