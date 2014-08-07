logger = require '../logger'


class Slave
  constructor: (@ws) ->
  
  processMessage: (message) ->
    console.log(message)


module.exports = Slave
