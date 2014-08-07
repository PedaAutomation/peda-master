logger = require './logger'

discovery = require './discovery'
db        = require './db'
async     = require 'async'


exports.init = (port, dbPath, cb) ->
  logger.info "Initializing PedaMaster on port " + port + "."
  
  async.parallel [
    (cb) ->
      discovery.init port, cb
    , (cb) ->
      db.init dbPath, cb
  ], cb
  
exports.start = ->
  logger.info "Starting PedaMaster."
  discovery.start()

exports.stop = (code) ->
  logger.info "Stopping PedaMaster."
  discovery.stop()
  db.stop()
  
  process.exit()
