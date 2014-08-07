class LogicCapability
  constructor: (@name, @regex) ->
    
  
  respondsTo: (cmd) ->
    return @regex.test cmd

module.exports = LogicCapability
