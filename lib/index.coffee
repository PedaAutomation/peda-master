discovery = require './discovery'
db        = require './db'
async     = require 'async'


exports.init = (port, dbPath, cb) ->
  console.log("Initializing PedaMaster on port " + port + ".")
  
  async.parallel [
    (cb) ->
      discovery.init port, cb
    , (cb) ->
      db.init dbPath, cb
  ], cb
  
exports.start = ->
  console.log("Starting PedaMaster.")
  discovery.start()
