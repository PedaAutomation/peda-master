logger = require '../logger'

orm = require 'orm'

database = null

exports.init = (path, cb) ->
  logger.info "Initializing Database."
  orm.connect path, (err, db) ->
    cb err if err
    database = db

    require('fs').readdirSync(require('path').join(__dirname, "models"))
    .filter((f) ->
      f.indexOf('.') != 0 && f != 'index.js'
    )
    .forEach (f) ->
      require('./models/' + f)(orm, db)
    
    logger.info "Database initialized!"
    
    cb()    

exports.stop = ->
  logger.info "Disconnecting database."
  # database.close()
  # swag
  logger.info "Database disconnected."
