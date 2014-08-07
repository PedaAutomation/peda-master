orm = require 'orm'

database = null

exports.init = (path, cb) ->
  console.log("Initializing Database.")
  orm.connect path, (err, db) ->
    cb err if err
    database = db

    require('fs').readdirSync(require('path').join(__dirname, "models"))
    .filter((f) ->
      f.indexOf('.') != 0 && f != 'index.js'
    )
    .forEach (f) ->
      require('./models/' + f)(orm, db)
    
    console.log("Database initialized!")
    
    cb()    
